<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">

<nav class="menu">
    <img class="logo" src="${pageContext.request.contextPath}/assets/logo.png">
    <ul>
        <li><a class="contex" href="${pageContext.request.contextPath}${URL_BASE}/HomeControlador?opcao=cancelar">HOME</a></li>
        <li><a class="contex" href="${pageContext.request.contextPath}${URL_BASE}/RankingControlador?opcao=cancelar">RANKING</a></li>
        <li><a class="contex" href="${pageContext.request.contextPath}/sobre.jsp">SOBRE</a></li>
        
        <%-- Controle Dinâmico: Login ou Logout dependendo da sessão --%>
        <c:choose>
            <c:when test="${not empty sessionScope.usuarioLogado}">
                <%-- Se está logado, a opção de sair passa pelo Controlador! --%>
                <li><a class="contex" href="${pageContext.request.contextPath}/LoginControlador?opcao=logout">LOGOUT</a></li>
            </c:when>
            <c:otherwise>
                <%-- Se não está logado --%>
                <li><a class="contex" href="${pageContext.request.contextPath}/login.jsp">LOGIN</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
    
    <div style="display: flex; align-items: center;">
        <%-- Ícone de Perfil Dinâmico --%>
        <c:choose>
            <c:when test="${not empty sessionScope.usuarioLogado}">
                <%-- Vai para a página de estatísticas se estiver logado --%>
                <span style="color: white; font-weight: bold; margin-right: 15px; font-size: 16px;">
                    Olá, ${sessionScope.usuarioLogado.nome}!
                </span>
                <a href="${pageContext.request.contextPath}/perfil.jsp" title="Meu Perfil">
     
                    <img class="redes" src="${pageContext.request.contextPath}/assets/perfil.png" alt="Perfil">
                </a>
            </c:when>
            
            <c:otherwise>
                <%-- Vai para o login se não estiver --%>
                <a href="${pageContext.request.contextPath}/login.jsp" title="Fazer Login">
                    <img class="redes" src="${pageContext.request.contextPath}/assets/login.png" alt="Login">
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>