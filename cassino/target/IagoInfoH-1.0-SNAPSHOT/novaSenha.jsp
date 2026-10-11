<%-- 
    Document   : novaSenha
    Created on : 11 de out. de 2026, 17:56:39
    Author     : Iagod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Criar Nova Senha</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    </head>
    <body>
        <%@include file="Menu.jsp" %>
        <h1>Cadastrar Nova Senha</h1>

        <form method="POST" action="${pageContext.request.contextPath}/RecuperacaoControlador">
            <input type="hidden" name="opcao" value="alterarSenha">
            <!-- Captura o token da URL e coloca no formulário -->
            <input type="hidden" name="token" value="${param.token}">
            
            <p><label>Nova Senha:</label> <input type="password" name="novaSenha" required size="40"></p>
            <div class="area-botoes">
                <input type="submit" value="Salvar Nova Senha">
            </div>
        </form>  
    </body>
</html>