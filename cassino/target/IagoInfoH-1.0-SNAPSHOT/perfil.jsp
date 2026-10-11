<%-- 
    Document   : perfil
    Created on : 15 de jun de 2026, 14:19:12
    Author     : 12409864678
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Proteção de tela: sem sessão, volta pro login (antes de escrever qualquer HTML) --%>
<c:if test="${empty sessionScope.usuarioLogado}">
    <c:redirect url="/login.jsp?msg=login" />
</c:if>

<%-- Se abriu direto pela URL, passa pelo controlador para carregar conquistas/carteira --%>
<c:if test="${empty perfilCarregado}">
    <c:redirect url="/PerfilControlador" />
</c:if>

<c:set var="u" value="${sessionScope.usuarioLogado}" />
<fmt:setLocale value="pt_BR" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Meu Perfil - Pig Jackpot</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
        <style>
            .perfil-wrap { max-width: 1100px; margin: 40px auto; padding: 0 20px; color: #fff; }

            .perfil-topo {
                display: flex; align-items: center; gap: 24px; flex-wrap: wrap;
                background: linear-gradient(135deg, #2b2b2b, #1a1a1a);
                border: 1px solid rgba(255, 215, 0, .4);
                border-radius: 20px; padding: 28px;
            }
            .avatar {
                width: 90px; height: 90px; border-radius: 50%;
                background: gold; color: #000; font-size: 42px; font-weight: bold;
                display: flex; align-items: center; justify-content: center;
            }
            .perfil-topo h1 { margin: 0 0 4px; }
            .perfil-topo small { opacity: .75; }

            .stats { display: flex; flex-wrap: wrap; gap: 16px; margin: 24px 0; }
            .stat {
                flex: 1 1 200px; background: #2b2b2b; border-radius: 16px;
                padding: 20px; text-align: center;
                border: 1px solid rgba(255, 255, 255, .08);
            }
            .stat .valor { font-size: 28px; font-weight: bold; color: gold; }
            .stat .rotulo { font-size: 13px; opacity: .8; }

            .bloco {
                background: #2b2b2b; border-radius: 16px; padding: 24px; margin-bottom: 24px;
                border: 1px solid rgba(255, 255, 255, .08);
            }
            .bloco h2 { margin-top: 0; }
            .bloco hr { border: 0; border-top: 1px solid rgba(255, 255, 255, .12); margin: 12px 0 18px; }

            .dados { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 10px 30px; }
            .dados p { margin: 4px 0; }

            .carteira { display: flex; flex-wrap: wrap; gap: 20px; }
            .carteira form {
                flex: 1 1 300px; background: #1f1f1f; border-radius: 14px; padding: 20px;
            }
            .carteira label { display: block; margin-bottom: 6px; font-size: 14px; }
            .carteira input[type=number], .carteira select {
                width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #555;
                background: #111; color: #fff; margin-bottom: 14px; box-sizing: border-box;
            }
            .btn {
                width: 100%; padding: 12px; border: 0; border-radius: 10px;
                font-weight: bold; cursor: pointer; font-size: 15px;
            }
            .btn-dep { background: #28a745; color: #fff; }
            .btn-saq { background: gold; color: #000; }
            .btn:hover { filter: brightness(1.1); }

            .alerta { padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; font-weight: bold; }
            .alerta.ok   { background: #1e7e34; }
            .alerta.erro { background: #a71d2a; }

            .conquistas { display: flex; flex-wrap: wrap; gap: 16px; }
            .conquista {
                flex: 1 1 220px; background: #1f1f1f; border-radius: 14px; padding: 18px;
                text-align: center; border: 1px solid rgba(255, 215, 0, .35);
            }
            .conquista .medalha { font-size: 40px; }
            .conquista h3 { margin: 8px 0 4px; }
            .conquista small { opacity: .75; }
            .vazio { text-align: center; opacity: .75; padding: 20px; }
        </style>
    </head>
    <body>
        <%@include file="Menu.jsp" %>

        <div class="perfil-wrap">

            <%-- Mensagens de retorno (sucesso/erro) --%>
            <c:if test="${not empty param.ok}">
                <div class="alerta ok">✅ <c:out value="${param.ok}" /></div>
            </c:if>
            <c:if test="${not empty param.erro}">
                <div class="alerta erro">⚠️ <c:out value="${param.erro}" /></div>
            </c:if>

            <%-- Cabeçalho --%>
            <div class="perfil-topo">
                <div class="avatar">${fn:toUpperCase(fn:substring(u.nome, 0, 1))}</div>
                <div>
                    <h1>${u.nome}</h1>
                    <small>${u.email}</small><br>
                    <small>Membro desde: ${u.data_cadastro}</small>
                </div>
            </div>

            <%-- Estatísticas rápidas --%>
            <div class="stats">
                <div class="stat">
                    <div class="valor">R$ <fmt:formatNumber value="${empty carteira ? 0 : carteira.saldo}" pattern="#,##0.00" /></div>
                    <div class="rotulo">Saldo disponível</div>
                </div>
                <div class="stat">
                    <div class="valor">${fn:length(conquistas)}</div>
                    <div class="rotulo">Conquistas desbloqueadas</div>
                </div>
            </div>

            <%-- Carteira: depósito e saque --%>
            <div class="bloco">
                <h2 id="carteira">💰 Minha Carteira</h2>
                <hr>
                <div class="carteira">

                    <form method="post" action="${pageContext.request.contextPath}${URL_BASE}/opCarteiraControlador">
                        <h3>Depositar</h3>
                        <input type="hidden" name="opcao" value="depositar">
                        <input type="hidden" name="origem" value="perfil">
                        <label for="valorDep">Valor (R$)</label>
                        <input type="number" id="valorDep" name="valor" min="0.01" step="0.01" required>
                        <button type="submit" class="btn btn-dep">Depositar</button>
                    </form>

                    <form method="post" action="${pageContext.request.contextPath}${URL_BASE}/opCarteiraControlador">
                        <h3>Sacar</h3>
                        <input type="hidden" name="opcao" value="realizar">
                        <input type="hidden" name="origem" value="perfil">
                        <label for="valorSaq">Valor (R$)</label>
                        <input type="number" id="valorSaq" name="valor" min="0.01" step="0.01" required>
                        <button type="submit" class="btn btn-saq">Sacar</button>
                    </form>

                </div>
            </div>

            <%-- Conquistas --%>
            <div class="bloco">
                <h2>🏆 Minhas Conquistas</h2>
                <hr>
                <c:choose>
                    <c:when test="${empty conquistas}">
                        <div class="vazio">Você ainda não desbloqueou nenhuma conquista. Jogue para ganhar a primeira!</div>
                    </c:when>
                    <c:otherwise>
                        <div class="conquistas">
                            <c:forEach var="uc" items="${conquistas}">
                                <div class="conquista">
                                    <div class="medalha">🏅</div>
                                    <h3>${uc.conquista.nome}</h3>
                                    <small>Conquistada em
                                        <fmt:formatDate value="${uc.data_conquista}" pattern="dd/MM/yyyy" />
                                    </small>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Dados pessoais --%>
            <div class="bloco">
                <h2>👤 Informações Pessoais</h2>
                <hr>
                <div class="dados">
                    <p><strong>Nome:</strong> ${u.nome}</p>
                    <p><strong>E-mail:</strong> ${u.email}</p>
                    <p><strong>Endereço:</strong> ${u.endereco}</p>
                    <p><strong>CPF:</strong> ${u.cpf}</p>
                </div>
            </div>

        </div>

        <footer class="footer-cassino">
            <div class="footer-copy">
                © 2026 Pig Jackpot - Todos os direitos reservados.
            </div>
        </footer>
    </body>
</html>