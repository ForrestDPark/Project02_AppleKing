<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ='top_admin.jsp' %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!--
--------------------------------------------------------------
* Description 	: Admin CRUD
* Author 		: PDG & KBS
* Date 			: 2024.02.05
* ---------------------------Update---------------------------		
* <<2024.02.04>> by PDG
    1. css 좀 함.. footer, top 추가 하고 사과 색깔로 맞춤. 
    2. 입력하다 수정하다 왔다 갔다 할수있게끔 어떻게 해야할까?
<<2024.02.05>> by PDG &KBS
    1. 입력기능 추가
    2.  
    3.  

    기능 설명 : 1. 상품코드를 불러오기 위해 js 를 사용하고 입력시, 상품 총 갯수에 +1을 하여 상품코드 란에 ReadOnly 로 출력한다.
    		  2. 상품 입력시, 자바스크립트로 정규식을 시행후 문제없이 통과시 
--------------------------------------------------------------
-->																									
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <style>
        body {
            text-align: center;
            background-color: rgb(255, 255, 200);
        }

        table {
            margin: 0 auto;
            border-collapse: collapse;
            width: 50%;
        }

        table, th, td {
            border: 1px solid black;
            white-space: nowrap;
            padding: 8px;
        }

        td input[type="text"] {
            width: 400px;
        }

        td:first-child {
            width: 150px;
        }

        td:nth-child(2) input[type="text"] {
            text-align: left;
        }

        .input-style input[type="text"] {
            width: calc(100% - 300px);
            box-sizing: border-box;
            text-align: left;
            float: left;
        }
        .ui-datepicker {
    background-color: #ffffff; /* 배경색을 흰색으로 설정 */
}

.ui-datepicker-calendar td {
    background-color: #ffffff; /* 달력 내부의 날짜 셀 배경색을 흰색으로 설정 */
}
    </style>
</head>
<body>
<form action="aProductListUpdate.do" method="post">     
<div id="productCount"></div>
<!--상품평 전체 조회 및 검색 결과 -->
<p><strong><h2>상품 목록 </h2></strong>
    <hr>
<p><strong> 상품 입력</strong>
<div>
    <table border="1">
        <tr>
            <td>상품코드:</td>
            <td class="input-style"><input type="text" id="product_code" placeholder="수정불가" readonly="readonly"></td>
        </tr>
        <tr>
            <td>상품명:</td>
            <td class="input-style"><input type="text" id="product_name" placeholder="상품명을 입력하세요" value="다사과"></td>
        </tr>
        <tr>
            <td>수량:</td>
            <td class="input-style"><input type="text" id="product_qty" placeholder="수량 입력" value="0"></td>
        </tr>
        <tr>
            <td>원산지:</td>
            <td class="input-style"><input type="text" id="origin" placeholder="원산지" value="한국"></td>
        </tr>
        <tr>
  		  <td>생산일:</td>
  		  <td class="input-style">
       		 <input type="text" id="manufacture_date" placeholder="생산일" value="2024-02-02">
    		</td>
		</tr>
            <td>무게(kg):</td>
            <td class="input-style"><input type="text" id="weight" placeholder="무게" value="15"></td>
        </tr>
        <tr>
            <td>사이즈:</td>
            <td class="input-style"><input type="text" id="size" placeholder="사이즈" value="대"></td>
        </tr>
        <tr>
            <td>상세 이미지:</td>
            <td class="input-style"><input type="text" id="detail_image_name" placeholder="수정불가" value="asdf.png"></td>
        </tr>
        <tr>
            <td>상품 등록일:</td>
            <td class="input-style"><input type="text" id="product_reg_date" readonly="readonly" placeholder="등록일 (자동)"></td>
        </tr>
        <tr>
            <td>품종:</td>
            <td class="input-style"><input type="text" id="kind" placeholder="품종" value="부사"></td>
        </tr>
        <tr>
            <td>섬네일 이미지:</td>
            <td class="input-style"><input type="text" id="product_image_names" placeholder="이미지파일" value="asdf.png"></td>
        </tr>
        <tr>
            <td>가격 :</td>
            <td class="input-style"><input type="text" id="price" placeholder="가격" value="15000"></td>
        </tr>
    </table>
</div>
<br>
<!--  submit 을 누르면 s~ 어쩌구가 submit 되어 js 에서 받아줌. 그 전에 정규표현식을 거치고 통과-->
<input type="button" id="insertBtn" value="입력" onclick="check()"></input>
<div id="Print_code"></div>
<!--  // result 부분을 Js 가 만들어주는구나 -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<footer>
    <p>&copy; 2024 Apple Store. All rights reserved.</p>
</footer>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/i18n/jquery-ui-i18n.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


<script>
$(function() {
    // 한국어로 지역화된 달력 적용
    $.datepicker.setDefaults($.datepicker.regional['ko']);
    
    // 달력 적용할 input 엘리먼트에 대해 datepicker() 메서드 호출
    $("#manufacture_date").datepicker();
});
    // 정규표현식을 위한 JS 추가
    function validateInput(element, pattern, errorMessage) {
        // 입력된 값이 패턴과 일치하는지 확인
        if (!pattern.test(element.value)) {
            alert(errorMessage);
            return false;
        }
        return true;
    }

    function check() {
        // 각 입력 필드에 대한 정규식 및 에러 메시지 설정
        const patterns = {
            product_qty: /^\d+$/,
            origin: /^[가-힣]+$/,
            weight: /^\d+$/,
            size: /^[가-힣]+$/,
            kind: /^[가-힣]+$/,
            price: /^\d+$/
        };
        const errorMessages = {
            product_qty: "수량은 숫자만 입력 가능합니다.",
            origin: "원산지는 한글만 입력 가능합니다.",
            weight: "무게는 숫자만 입력 가능합니다.",
            size: "사이즈는 한글만 입력 가능합니다.",
            kind: "품종은 한글만 입력 가능합니다.",
            price: "가격은 숫자만 입력 가능합니다."
        };

        // 각 입력 필드에 대한 유효성 검사 수행
        for (const field in patterns) {
            if (field !== "product_code" && field !== "product_reg_date" && field !== "detail_image_name") {
                // product_code, product_reg_date, detail_image_name은 readonly이거나 자동 생성이므로 제외
                const element = document.getElementById(field);
                if (!validateInput(element, patterns[field], errorMessages[field])) {
                    return; // 유효성 검사에 실패한 경우 함수 종료
                }
            }
        }
        form.submit();
    }      
</script>
</form>
</body>
</html>
