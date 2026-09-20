<%-- 
    Document   : opCarteira
    Created on : 29 de jun. de 2026, 12:05:45
    Author     : Iagod
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="Latin1"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=Latin1">
        <title>Operacoes de Carteira</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forms.css">
    </head>

    <%@include file="Menu.jsp" %>

    <body>
        <div class="container">

            <h3>${mensagem}</h3>

            <%-- FORMULARIO DE SAQUE --%>
            
            <h1 class="secao-titulo">REALIZAR SAQUE</h1>

            <form name="saqueForm"
                  method="get"
                  action="${pageContext.request.contextPath}${URL_BASE}/opCarteiraControlador">

                <input type="hidden" name="opcao" value="realizar">

                <p>
                    <label>Usuario:</label>
                    <select name="usuario" required>
                        <option value="">Selecione...</option>
                        <c:forEach var="usuarios" items="${listaUsuario}">
                            <option value="${usuarios.id_usuario}">
                                ${usuarios.nome}
                            </option>
                        </c:forEach>
                    </select>
                </p>

                <p>
                    <label>Data:</label>
                    <input type="date" name="data" required>
                </p>

                <p>
                    <label>Valor do Saque:</label>
                    <input type="number" name="valor" required step="0.01" min="0.01">
                </p>

                <div class="botoes-alinhados">
                    <input type="submit" value="Realizar Saque">
                    <a href="${pageContext.request.contextPath}${URL_BASE}/opCarteiraControlador?opcao=cancelar" class="btn-cancelar-inline">Cancelar</a>
                </div>
            </form>


            <%-- FORMULARIO DE DEPOSITO --%>
            
            <h1 class="secao-titulo">REALIZAR DEPOSITO</h1>

            <form name="depositoForm"
                  method="get"
                  action="${pageContext.request.contextPath}${URL_BASE}/opCarteiraControlador">

                <input type="hidden" name="opcao" value="depositar">

                <p>
                    <label>Usuario:</label>
                    <select name="usuario" required>
                        <option value="">Selecione...</option>
                        <c:forEach var="usuarios" items="${listaUsuario}">
                            <option value="${usuarios.id_usuario}">
                                ${usuarios.nome}
                            </option>
                        </c:forEach>
                    </select>
                </p>

                <p>
                    <label>Data:</label>
                    <input type="date" name="data" required>
                </p>

                <p>
                    <label>Valor do Deposito:</label>
                    <input type="number" name="valor" required step="0.01" min="0.01">
                </p>

                <div class="botoes-alinhados">
                    <input type="submit" value="Realizar Deposito">
                    <a href="${pageContext.request.contextPath}${URL_BASE}/opCarteiraControlador?opcao=cancelar" class="btn-cancelar-inline">Cancelar</a>
                </div>
            </form>


            <%-- ========================================= --%>
            <%-- SECAO DE CARTEIRAS                        --%>
            <%-- ========================================= --%>
            <h1 class="secao-titulo">CONSULTAR CARTEIRAS</h1>

            <div class="cards-container">
                <c:forEach var="carteiras" items="${listaCarteira}">
                    <div class="user-card">
                        <h4>Usuario: ${carteiras.usuario.nome}</h4>
                        <p>Clique para visualizar o saldo</p>
                        
                        <button type="button" class="btn-mostrar" 
                                onclick="abrirModal('${carteiras.usuario.nome}', '${carteiras.saldo}')">
                            Mostrar
                        </button>
                    </div>
                </c:forEach>
            </div>

        </div>

        <%-- ESTRUTURA DO MODAL --%>
        <div id="modalCarteira" class="modal">
            <div class="modal-content">
                <h3 id="modalNomeUsuario">Carteira</h3>
                <p>Saldo disponivel</p>
                <div id="modalSaldoUsuario" class="modal-saldo">R$ 0,00</div>
                <button class="btn-fechar" onclick="fecharModal()">Fechar</button>
            </div>
        </div>

        <script>
            function abrirModal(nome, saldo) {
                const valorNumerico = parseFloat(saldo);
                const saldoFormatado = isNaN(valorNumerico) ? "R$ 0,00" : valorNumerico.toLocaleString('pt-BR', {
                    style: 'currency',
                    currency: 'BRL'
                });
                
                document.getElementById('modalNomeUsuario').innerText = "Carteira de " + nome;
                document.getElementById('modalSaldoUsuario').innerText = saldoFormatado;
                
                document.getElementById('modalCarteira').style.display = 'flex';
            }

            function fecharModal() {
                document.getElementById('modalCarteira').style.display = 'none';
            }

            window.onclick = function(event) {
                const modal = document.getElementById('modalCarteira');
                if (event.target === modal) {
                    fecharModal();
                }
            }
        </script>
    </body>
</html>