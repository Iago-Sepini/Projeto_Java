<%-- 
    Document   : index
    Created on : 9 de fev. de 2026, 14:39:36
    Author     : Tulio Dias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/area-jogador.css">

<%-- 
    Controle de sessão:
    "usuarioLogado" é o atributo que o LoginControlador grava na sessão.
    Visitante vê tudo, mas todo botão leva para o login.
--%>
<c:set var="logado" value="${not empty sessionScope.usuarioLogado}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="base" value="${ctx}${URL_BASE}" />
<c:set var="loginUrl" value="${ctx}/login.jsp?msg=login" />

<%-- Destinos dos botões (quando logado) --%>
<c:set var="urlCarteira"   value="${ctx}/PerfilControlador#carteira" />
<c:set var="urlPerfil"     value="${ctx}/PerfilControlador" />
<c:set var="urlTransacoes" value="${ctx}/AreaJogador?pagina=transacoes" />
<c:set var="urlConquistas" value="${ctx}/AreaJogador?pagina=conquistas" />
<c:set var="urlApostas"    value="${base}/ApostaControlador?opcao=cancelar" />
<c:set var="urlBonus"      value="${base}/BonusControlador?opcao=cancelar" />
<c:set var="urlJogos"      value="${base}/JogoControlador?opcao=cancelar" />

<%@include file="Menu.jsp" %>

<%-- Faixa de status da sessão --%>
<c:choose>
    <c:when test="${logado}">
        <div class="aviso-sessao on">
            ✅ Você está conectado como ${sessionScope.usuarioLogado.nome}
        </div>
    </c:when>
    <c:otherwise>
        <div class="aviso-sessao off">
            🔒 Você está navegando como visitante. Para jogar, apostar ou movimentar a carteira,
            <a href="${loginUrl}">faça login</a>.
        </div>
    </c:otherwise>
</c:choose>

<div class="banner-cassino">
    <div class="overlay">
        <c:choose>
            <c:when test="${logado}">
                <h1>Bem-vindo de volta, ${sessionScope.usuarioLogado.nome}!</h1>
                <p>boa sorte nas suas jogadas 💰</p>
            </c:when>
            <c:otherwise>
                <h1>Bem-vindo ao Cassino Online</h1>
                <p>encontre o poder 💰</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- ===================== JOGOS NOVOS ===================== --%>
<section class="jogos-recentes">

    <h1 class="titulo-jogos">Jogos Novos</h1>

    <div class="linha-jogos">

        <c:forEach var="jogo" items="${recentes}" begin="0" end="1">
            <div class="card-jogo">

                <img src="${ctx}/assets/jogoNovo.jfif">

                <div class="conteudo-jogo">
                    <h2>${jogo.nome}</h2>
                    <p>${jogo.descricao}</p>

                    <c:choose>
                        <c:when test="${logado}">
                            <a class="btn-card" href="${base}/PartidaControlador?opcao=novo&idJogo=${jogo.id_jogo}">🎮 Jogar</a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn-card bloqueado" href="${loginUrl}">🔒 Entrar para jogar</a>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </c:forEach>

        <c:if test="${empty recentes}">
            <p style="text-align:center">Nenhum jogo novo cadastrado ainda.</p>
        </c:if>

    </div>

</section>

<%-- ===================== ÁREA DO JOGADOR ===================== --%>
<section class="area-jogador">

    <h1 class="titulo-jogos">Área do Jogador</h1>

    <div class="grade">

        <div class="card-area ${logado ? '' : 'bloqueado'}">
            <c:if test="${!logado}"><span class="cadeado">🔒</span></c:if>
            <div class="icone">👛</div>
            <h2>Minha Carteira</h2>
            <p>Consulte seu saldo e faça depósitos e saques.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlCarteira : loginUrl}">
                ${logado ? 'Abrir carteira' : '🔒 Entrar'}
            </a>
        </div>

        <div class="card-area ${logado ? '' : 'bloqueado'}">
            <c:if test="${!logado}"><span class="cadeado">🔒</span></c:if>
            <div class="icone">🎲</div>
            <h2>Minhas Apostas</h2>
            <p>Veja o histórico das suas apostas e resultados.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlApostas : loginUrl}">
                ${logado ? 'Ver apostas' : '🔒 Entrar'}
            </a>
        </div>

        <div class="card-area ${logado ? '' : 'bloqueado'}">
            <c:if test="${!logado}"><span class="cadeado">🔒</span></c:if>
            <div class="icone">🧾</div>
            <h2>Transações</h2>
            <p>Acompanhe todas as movimentações financeiras da conta.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlTransacoes : loginUrl}">
                ${logado ? 'Ver transações' : '🔒 Entrar'}
            </a>
        </div>

        <div class="card-area ${logado ? '' : 'bloqueado'}">
            <c:if test="${!logado}"><span class="cadeado">🔒</span></c:if>
            <div class="icone">🏆</div>
            <h2>Conquistas</h2>
            <p>Desbloqueie troféus conforme você joga.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlConquistas : loginUrl}">
                ${logado ? 'Ver conquistas' : '🔒 Entrar'}
            </a>
        </div>

        <div class="card-area ${logado ? '' : 'bloqueado'}">
            <c:if test="${!logado}"><span class="cadeado">🔒</span></c:if>
            <div class="icone">🎁</div>
            <h2>Meus Bônus</h2>
            <p>Resgate e acompanhe os bônus disponíveis para você.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlBonus : loginUrl}">
                ${logado ? 'Ver bônus' : '🔒 Entrar'}
            </a>
        </div>

        <div class="card-area ${logado ? '' : 'bloqueado'}">
            <c:if test="${!logado}"><span class="cadeado">🔒</span></c:if>
            <div class="icone">🧑</div>
            <h2>Meu Perfil</h2>
            <p>Veja seus dados, saldo e conquistas em um só lugar.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlPerfil : loginUrl}">
                ${logado ? 'Abrir perfil' : '🔒 Entrar'}
            </a>
        </div>

    </div>

</section>

<%-- ===================== PROMOÇÕES ===================== --%>
<section class="promocoes">

    <h1 class="titulo-jogos">Promoções</h1>

    <div class="grade">

        <div class="card-area">
            <span class="promo-tag">NOVO JOGADOR</span>
            <div class="icone">🎉</div>
            <h2>Bônus de Boas-vindas</h2>
            <p>Ganhe um bônus no seu primeiro depósito.</p>
            <c:choose>
                <c:when test="${logado}">
                    <a class="btn-card verde" href="${urlCarteira}">Depositar agora</a>
                </c:when>
                <c:otherwise>
                    <a class="btn-card verde" href="${ctx}/CadastrarUsuario.jsp">Criar conta</a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="card-area">
            <span class="promo-tag">SEMANAL</span>
            <div class="icone">🔥</div>
            <h2>Rodada em Dobro</h2>
            <p>Aproveite multiplicadores especiais nos jogos em destaque.</p>
            <a class="btn-card ${logado ? '' : 'bloqueado'}" href="${logado ? urlJogos : loginUrl}">
                ${logado ? 'Ver jogos' : '🔒 Entrar'}
            </a>
        </div>

        <div class="card-area">
            <span class="promo-tag">FIDELIDADE</span>
            <div class="icone">⭐</div>
            <h2>Conquiste e Ganhe</h2>
            <p>Cada conquista desbloqueada pode render recompensas.</p>
            <a class="btn-card contorno" href="${logado ? urlConquistas : loginUrl}">Ver conquistas</a>
        </div>

    </div>

</section>

<%-- ===================== COMO FUNCIONA ===================== --%>
<section class="como-funciona">

    <h1 class="titulo-jogos">Como Funciona</h1>

    <div class="grade">

        <div class="card-area passo">
            <div class="numero">1</div>
            <h2>Crie sua conta</h2>
            <p>Cadastre-se gratuitamente e faça login.</p>
        </div>

        <div class="card-area passo">
            <div class="numero">2</div>
            <h2>Deposite</h2>
            <p>Adicione saldo à sua carteira com segurança.</p>
        </div>

        <div class="card-area passo">
            <div class="numero">3</div>
            <h2>Jogue e aposte</h2>
            <p>Escolha um jogo, faça sua aposta e boa sorte.</p>
        </div>

        <div class="card-area passo">
            <div class="numero">4</div>
            <h2>Saque</h2>
            <p>Retire seus ganhos quando quiser.</p>
        </div>

    </div>

</section>

<footer class="footer-cassino">
    <div class="footer-conteudo">
        <div>
            <h2>Pig Jackpot</h2>
        </div>
        <div>
            <ul>
                <li><a href="#">Home</a></li>
            </ul>
        </div>
        <div>
            <div class="footer-redes">
                <a href="https://instagram.com/seuUsuario" target="_blank">
                    <img class="redes" src="${ctx}/assets/instagram.png">
                </a>
                <a href="https://github.com/IagoDSN/PigJackpot" target="_blank">
                    <img class="redes" src="${ctx}/assets/github.png">
                </a>
            </div>
        </div>
    </div>
    <div class="footer-copy">
        © 2026 Pig Jackpot - Todos os direitos reservados.
    </div>
</footer>