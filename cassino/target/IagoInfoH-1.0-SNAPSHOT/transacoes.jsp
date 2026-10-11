<%-- 
    Document   : transacoes
    Created on : 11 de out. de 2026, 19:51:52
    Author     : Iagod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Sem sessão: login. Aberta direto pela URL: passa pelo controlador. --%>
<c:if test="${empty sessionScope.usuarioLogado}">
    <c:redirect url="/login.jsp?msg=login" />
</c:if>
<c:if test="${empty areaCarregada}">
    <c:redirect url="/AreaJogador?pagina=transacoes" />
</c:if>
<fmt:setLocale value="pt_BR" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Minhas Transações - Pig Jackpot</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/area-jogador.css">
    </head>
    <body>
        <%@include file="Menu.jsp" %>

        <div class="area-wrap">
            <h1>🧾 Minhas Transações</h1>
            <p class="area-sub">Todas as movimentações financeiras da sua conta.</p>

            <c:if test="${not empty erro}">
                <div class="msg-erro">⚠️ <c:out value="${erro}" /></div>
            </c:if>

            <div class="resumo">
                <div class="item">
                    <div class="valor verde">R$ <fmt:formatNumber value="${totalDepositos}" pattern="#,##0.00" /></div>
                    <div class="rotulo">Total depositado</div>
                </div>
                <div class="item">
                    <div class="valor">R$ <fmt:formatNumber value="${totalSaques}" pattern="#,##0.00" /></div>
                    <div class="rotulo">Total sacado</div>
                </div>
                <div class="item">
                    <div class="valor">${empty transacoes ? 0 : transacoes.size()}</div>
                    <div class="rotulo">Movimentações</div>
                </div>
            </div>

            <div class="tabela-wrap">
                <c:choose>
                    <c:when test="${empty transacoes}">
                        <div class="vazio">Você ainda não fez nenhuma movimentação.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="tabela">
                            <thead>
                                <tr><th>Data</th><th>Tipo</th><th>Valor</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${transacoes}">
                                    <tr>
                                        <td><fmt:formatDate value="${t.data}" pattern="dd/MM/yyyy" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${t.tipo == 'DEPOSITO'}"><span class="tag deposito">Depósito</span></c:when>
                                                <c:when test="${t.tipo == 'SAQUE'}"><span class="tag saque">Saque</span></c:when>
                                                <c:otherwise><span class="tag outro"><c:out value="${t.tipo}" /></span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>R$ <fmt:formatNumber value="${t.valor}" pattern="#,##0.00" /></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <div style="text-align:center; margin-top: 24px;">
                <a class="btn-card verde" href="${pageContext.request.contextPath}/PerfilControlador#carteira">Depositar / Sacar</a>
            </div>
        </div>

        <footer class="footer-cassino">
            <div class="footer-copy">© 2026 Pig Jackpot - Todos os direitos reservados.</div>
        </footer>
    </body>
</html>
