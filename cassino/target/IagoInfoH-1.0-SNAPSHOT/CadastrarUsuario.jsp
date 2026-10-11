<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Biblioteca para ler o texto e definir a cor verde/vermelha --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Novo Cadastro - Pig Jackpot</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        
        <style>
            /* Estilos modernos do card (mesmo padrão do login, mas um pouco mais largo) */
            .cadastro-wrapper {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 75vh;
                padding: 40px 20px;
            }
            .cadastro-box {
                background-color: #2b2b2b;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.7);
                width: 100%;
                max-width: 600px;
                text-align: center;
            }
            .cadastro-box h1 {
                color: #ffd700; 
                margin-bottom: 25px;
                font-size: 28px;
            }
            
            /* Usando Flexbox para colocar campos lado a lado */
            .linha-inputs {
                display: flex;
                gap: 15px;
            }
            .input-group {
                margin-bottom: 20px;
                text-align: left;
                flex: 1; /* Faz as colunas dividirem o espaço igual */
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
            
            /* Botões */
            .area-botoes-form {
                display: flex;
                gap: 15px;
                margin-top: 20px;
            }
            .btn-primario {
                background-color: #ffd700;
                color: #1a1a1a;
                border: none;
                padding: 14px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 8px;
                cursor: pointer;
                flex: 2;
                transition: background 0.3s, transform 0.1s;
            }
            .btn-primario:hover {
                background-color: #ffea00;
                transform: translateY(-2px);
            }
            .btn-secundario {
                background-color: transparent;
                color: #ffd700;
                border: 2px solid #ffd700;
                padding: 14px;
                font-size: 16px;
                font-weight: bold;
                border-radius: 8px;
                cursor: pointer;
                flex: 1;
                text-decoration: none;
                transition: all 0.3s;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .btn-secundario:hover {
                background-color: #ffd700;
                color: #1a1a1a;
            }
            
            /* Alertas */
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
        
        <div class="cadastro-wrapper">
            <div class="cadastro-box">
                <h1>Criar Nova Conta</h1>

                <%-- Controle de Cores da Mensagem --%>
                <c:if test="${not empty mensagem}">
                    <c:choose>
                        <c:when test="${fn:containsIgnoreCase(mensagem, 'sucesso')}">
                            <div class="msg-sucesso">${mensagem}</div>
                        </c:when>
                        <c:otherwise>
                            <div class="msg-erro">${mensagem}</div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <form name="formCadastro" method="POST" action="${pageContext.request.contextPath}/LoginControlador">
                    <input type="hidden" name="opcao" value="cadastrar">

                    <div class="input-group">
                        <label>Nome Completo:</label>
                        <input type="text" name="nome" required placeholder="Ex: João da Silva">
                    </div>
                    
                    <div class="input-group">
                        <label>E-mail:</label>
                        <input type="email" name="email" required placeholder="seuemail@exemplo.com">
                    </div>

                    <%-- CPF e Data de Nascimento lado a lado para economizar espaço --%>
                    <div class="linha-inputs">
                        <div class="input-group">
                            <label>CPF:</label>
                            <input type="text" name="cpf" required placeholder="Apenas números">
                        </div>
                        
                        <div class="input-group">
                            <label>Data de Nascimento:</label>
                            <input type="date" name="dataNascimento" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label>Endereço:</label>
                        <input type="text" name="endereco" required placeholder="Rua, Número, Bairro">
                    </div>

                    <div class="input-group">
                        <label>Senha:</label>
                        <input type="password" name="senha" required placeholder="Crie uma senha forte">
                    </div>

                    <div class="area-botoes-form">
                        <input type="submit" value="Criar Conta" class="btn-primario">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-secundario">Cancelar</a>
                    </div>
                </form>  
            </div>
        </div>

        <footer class="footer-cassino">
            <div class="footer-conteudo">
                <div><h2>Pig Jackpot</h2></div>
                <div><ul><li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li></ul></div>
                <div class="footer-copy">© 2026 Pig Jackpot - Todos os direitos reservados.</div>
            </div>
        </footer>
    </body>
</html>