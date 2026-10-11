<%-- 
    Document   : login
    Created on : 3 de out. de 2026, 19:46:35
    Author     : Iagod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Adicionando a biblioteca de funções para ler o texto da mensagem --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login - Pig Jackpot</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        
        <style>
            .login-wrapper {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 65vh;
                padding: 20px;
            }
            .login-box {
                background-color: #2b2b2b;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.7);
                width: 100%;
                max-width: 400px;
                text-align: center;
            }
            .login-box h1 {
                color: #ffd700;
                margin-bottom: 25px;
                font-size: 28px;
            }
            .input-group {
                margin-bottom: 20px;
                text-align: left;
            }
            .input-group label {
                display: block;
                color: #ccc;
                margin-bottom: 8px;
                font-weight: bold;
                font-size: 14px;
            }
            .input-group input {
                width: 100%;
                padding: 12px;
                border: 1px solid #444;
                border-radius: 8px;
                background-color: #1a1a1a;
                color: white;
                box-sizing: border-box;
                font-size: 16px;
            }
            .input-group input:focus {
                outline: none;
                border-color: #ffd700;
                box-shadow: 0 0 8px rgba(255, 215, 0, 0.4);
            }
            .btn-login {
                background-color: #ffd700;
                color: #1a1a1a;
                border: none;
                padding: 14px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 8px;
                cursor: pointer;
                width: 100%;
                transition: background 0.3s, transform 0.1s;
                margin-top: 10px;
            }
            .btn-login:hover {
                background-color: #ffea00;
                transform: translateY(-2px);
            }
            .login-links {
                margin-top: 25px;
                font-size: 14px;
                color: #aaa;
            }
            .login-links a {
                color: #ffd700;
                text-decoration: none;
                font-weight: bold;
                transition: color 0.3s;
            }
            .login-links a:hover {
                color: #fff;
                text-decoration: underline;
            }
            .msg-sucesso {
                color: #4CAF50;
                background-color: rgba(76, 175, 80, 0.1);
                padding: 12px;
                border-radius: 8px;
                border: 1px solid #4CAF50;
                margin-bottom: 20px;
                font-size: 14px;
                font-weight: bold;
            }
            .msg-erro {
                color: #ff4d4d;
                background-color: rgba(255, 77, 77, 0.1);
                padding: 12px;
                border-radius: 8px;
                border: 1px solid #ff4d4d;
                margin-bottom: 20px;
                font-size: 14px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <%@include file="Menu.jsp" %>
        
        <div class="login-wrapper">
            <div class="login-box">
                <h1>Acessar Conta</h1>

                <%-- Lógica Inteligente de Cores para as Mensagens --%>
                <c:if test="${not empty mensagem}">
                    <c:choose>
                        <%-- Se a mensagem contiver a palavra "sucesso", fica verde --%>
                        <c:when test="${fn:containsIgnoreCase(mensagem, 'sucesso')}">
                            <div class="msg-sucesso">${mensagem}</div>
                        </c:when>
                        <%-- Caso contrário (erros), fica vermelho --%>
                        <c:otherwise>
                            <div class="msg-erro">${mensagem}</div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <form name="formLogin" method="POST" action="${pageContext.request.contextPath}/LoginControlador">
                    <input type="hidden" name="opcao" value="logar">

                    <div class="input-group">
                        <label>E-mail:</label>
                        <input type="email" name="email" required placeholder="Digite seu e-mail">
                    </div>
                    
                    <div class="input-group">
                        <label>Senha:</label>
                        <input type="password" name="senha" required placeholder="Digite sua senha">
                    </div>

                    <input type="submit" value="Entrar" class="btn-login">
                    
                    <div class="login-links">
                        <p>Não tem uma conta? <a href="${pageContext.request.contextPath}/CadastrarUsuario.jsp">Cadastre-se aqui</a></p>
                        <p style="margin-top: 10px;"><a href="${pageContext.request.contextPath}/recuperarSenha.jsp">Esqueci minha senha</a></p>
                    </div>
                </form>  
            </div>
        </div>

        <footer class="footer-cassino">
            <div class="footer-conteudo">
                <div><h2>Pig Jackpot</h2></div>
                <div><ul><li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li></ul></div>
                <div>
                    <div class="footer-redes">
                        <a href="#" target="_blank"><img class="redes" src="${pageContext.request.contextPath}/assets/instagram.png"></a>
                        <a href="#" target="_blank"><img class="redes" src="${pageContext.request.contextPath}/assets/github.png"></a>
                    </div>
                </div>
            </div>
            <div class="footer-copy">© 2026 Pig Jackpot - Todos os direitos reservados.</div>
        </footer>
    </body>
</html>