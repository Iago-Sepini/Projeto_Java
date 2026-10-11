<%-- 
    Document   : recuperarSenha
    Created on : 11 de out. de 2026, 17:55:55
    Author     : Iagod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Recuperar Senha</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    </head>
    <body>
        <%@include file="Menu.jsp" %>
        <h1>Esqueci minha senha</h1>
        
        <c:if test="${not empty mensagem}">
            <h3 style="color: yellow; text-align: center;">${mensagem}</h3>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/RecuperacaoControlador">
            <input type="hidden" name="opcao" value="enviarEmail">
            <p><label>Digite seu E-mail:</label> <input type="email" name="email" required size="40"></p>
            <div class="area-botoes">
                <input type="submit" value="Enviar Link de Recuperação">
                <a class="btn-link" href="${pageContext.request.contextPath}/login.jsp">Voltar</a>
            </div>
        </form>  
    </body>
</html>