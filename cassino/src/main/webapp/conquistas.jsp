<%-- 
    Document   : conquistas
    Created on : 11 de out. de 2026, 19:52:33
    Author     : Iagod
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty sessionScope.usuarioLogado}">
    <c:redirect url="/login.jsp?msg=login" />
</c:if>
<c:if test="${empty areaCarregada}">
    <c:redirect url="/AreaJogador?pagina=conquistas" />
</c:if>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Minhas Conquistas - Pig Jackpot</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/area-jogador.css">
    </head>
    <body>
        <%@include file="Menu.jsp" %>

        <div class="area-wrap">
            <h1>🏆 Minhas Conquistas</h1>
            <p class="area-sub">
                Você desbloqueou <strong>${empty qtdDesbloqueadas ? 0 : qtdDesbloqueadas}</strong>
                de <strong>${empty qtdTotal ? 0 : qtdTotal}</strong> conquistas.
            </p>

            <c:if test="${not empty erro}">
                <div class="msg-erro">⚠️ <c:out value="${erro}" /></div>
            </c:if>

            <div class="barra"><div style="width: ${empty percentual ? 0 : percentual}%"></div></div>

            <c:choose>
                <c:when test="${empty todasConquistas}">
                    <div class="vazio">Nenhuma conquista cadastrada ainda.</div>
                </c:when>
                <c:otherwise>
                    <div class="lista-conquistas">
                        <c:forEach var="c" items="${todasConquistas}">
                            <c:set var="dataConq" value="${desbloqueadas[c.id_conquista]}" />
                            <c:choose>
                                <c:when test="${not empty dataConq}">
                                    <div class="conq">
                                        <div class="medalha">🏅</div>
                                        <h3><c:out value="${c.nome}" /></h3>
                                        <small>Conquistada em <fmt:formatDate value="${dataConq}" pattern="dd/MM/yyyy" /></small>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="conq trancada">
                                        <div class="medalha">🔒</div>
                                        <h3><c:out value="${c.nome}" /></h3>
                                        <small>Ainda não desbloqueada</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <footer class="footer-cassino">
            <div class="footer-copy">© 2026 Pig Jackpot - Todos os direitos reservados.</div>
        </footer>
    </body>
</html>

