/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.edu.ifsuldeminas.infoh2026.controlador;

import br.edu.ifsuldeminas.infoh2026.modelo.dao.CarteiraDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.SaqueDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.DepositoDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.TransacaoDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Carteira;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Deposito;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Saque;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Transacao;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Usuario;
import br.edu.ifsuldeminas.infoh2026.servico.WebConstante;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author Iagod
 */
@WebServlet(WebConstante.BASE_PATH + "/opCarteiraControlador")
public class opCarteiraControlador extends HttpServlet {

    private SaqueDAO saqueDao;
    private DepositoDAO depositoDao;
    private CarteiraDAO carteiraDao;
    private TransacaoDAO transacaoDao;
    private UsuarioDAO usuarioDao;

    @Override
    public void init() throws ServletException {

        saqueDao = new SaqueDAO();
        depositoDao = new DepositoDAO();
        carteiraDao = new CarteiraDAO();
        transacaoDao = new TransacaoDAO();
        usuarioDao = new UsuarioDAO();

    }

    // Formulários (perfil) usam POST; links antigos continuam usando GET
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Vindo do perfil: exige usuário logado na sessão
        if (veioDoPerfil(request) && usuarioDaSessao(request) == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login");
            return;
        }

        String opcao = request.getParameter("opcao");

        if (opcao == null || opcao.isEmpty()) {
            opcao = "cancelar";
        }

        switch (opcao) {

            case "realizar":
                realizarSaque(request, response);
                break;
            case "depositar":
                realizarDeposito(request, response);
                break;

            case "cancelar":
                cancelar(request, response);
                break;

            default:
                cancelar(request, response);
                break;
        }

    }

    ///////////////////////////////////////////// AUXILIARES ///////////////////////////////////////////////////////////////
    private boolean veioDoPerfil(HttpServletRequest request) {
        return "perfil".equals(request.getParameter("origem"));
    }

    private Usuario usuarioDaSessao(HttpServletRequest request) {
        return (Usuario) request.getSession().getAttribute("usuarioLogado");
    }

    // No perfil o usuário é SEMPRE o da sessão (ignora o parâmetro, que poderia ser adulterado)
    private Integer resolverIdUsuario(HttpServletRequest request) {
        if (veioDoPerfil(request)) {
            return usuarioDaSessao(request).getId_usuario();
        }
        return Integer.valueOf(request.getParameter("usuario"));
    }

    // Se a data não vier no formulário, usa a data de hoje
    private Date resolverData(HttpServletRequest request) {
        String d = request.getParameter("data");
        if (d == null || d.isEmpty()) {
            return Date.valueOf(LocalDate.now());
        }
        return Date.valueOf(d);
    }

    // Do perfil: volta para o perfil com ?ok= / ?erro=. Das outras telas: comportamento antigo.
    private void finalizar(HttpServletRequest request, HttpServletResponse response,
            String mensagem, boolean sucesso)
            throws ServletException, IOException {

        if (veioDoPerfil(request)) {
            String chave = sucesso ? "ok" : "erro";
            response.sendRedirect(request.getContextPath() + "/PerfilControlador?" + chave + "="
                    + URLEncoder.encode(mensagem, StandardCharsets.UTF_8));
            return;
        }

        request.setAttribute("mensagem", mensagem);
        abrirPagina(request, response);
    }

    ///////////////////////////////////////////// SAQUE /////////////////////////////////////////////////////////////////////////
    private void realizarSaque(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Integer idUsuario = resolverIdUsuario(request);
            Double valor = Double.valueOf(request.getParameter("valor"));
            Date data = resolverData(request);

            if (valor <= 0) {
                finalizar(request, response, "Informe um valor maior que zero.", false);
                return;
            }

            Usuario usuario = usuarioDao.buscarUsuarioPorId(idUsuario);

            if (usuario == null) {
                finalizar(request, response, "Usuário não encontrado.", false);
                return;
            }

            Carteira carteira = carteiraDao.buscarCarteiraPorUsuario(idUsuario);

            if (carteira == null) {
                finalizar(request, response, "Carteira não encontrada.", false);
                return;
            }

            if (carteira.getSaldo() < valor) {
                finalizar(request, response, "Saldo insuficiente.", false);
                return;
            }

            //==============================
            // SALVA O SAQUE
            //==============================
            Saque objSaque = new Saque();
            objSaque.setData(data);
            objSaque.setValor_total(valor);
            objSaque.setUsuario(usuario);
            saqueDao.salvar(objSaque);

            //==============================
            // ATUALIZA A CARTEIRA
            //==============================
            carteira.setSaldo(carteira.getSaldo() - valor);
            carteiraDao.alterar(carteira);

            //==============================
            // REGISTRA A TRANSAÇÃO
            //==============================
            Transacao objTransacao = new Transacao();
            objTransacao.setValor(valor);
            objTransacao.setTipo("SAQUE");
            objTransacao.setData(data);
            objTransacao.setUsuario(usuario);
            transacaoDao.salvar(objTransacao);

            finalizar(request, response, "Saque realizado com sucesso!", true);

        } catch (Exception e) {
            finalizar(request, response, "Erro ao realizar saque: " + e.getMessage(), false);
        }

    }

    ///////////////////////////////////////////// DEPÓSITO /////////////////////////////////////////////////////////////////////////
    private void realizarDeposito(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Integer idUsuario = resolverIdUsuario(request);
            Double valor = Double.valueOf(request.getParameter("valor"));
            Date data = resolverData(request);

            if (valor <= 0) {
                finalizar(request, response, "Informe um valor maior que zero.", false);
                return;
            }

            Usuario usuario = usuarioDao.buscarUsuarioPorId(idUsuario);
            if (usuario == null) {
                finalizar(request, response, "Usuário não encontrado.", false);
                return;
            }

            Carteira carteira = carteiraDao.buscarCarteiraPorUsuario(idUsuario);

            // Primeiro depósito: cria a carteira do usuário com saldo zero
            if (carteira == null) {
                Carteira nova = new Carteira();
                nova.setSaldo(0.0);
                nova.setUsuario(usuario);
                carteiraDao.salvar(nova);
                carteira = carteiraDao.buscarCarteiraPorUsuario(idUsuario);
            }

            if (carteira == null) {
                finalizar(request, response, "Carteira não encontrada.", false);
                return;
            }

            //==============================
            // SALVA O DEPOSITO
            //==============================
            Deposito objDeposito = new Deposito();
            objDeposito.setData(data);
            objDeposito.setValor_total(valor);
            objDeposito.setUsuario(usuario);
            depositoDao.salvar(objDeposito);

            //==============================
            // ATUALIZA A CARTEIRA (SOMANDO)
            //==============================
            carteira.setSaldo(carteira.getSaldo() + valor);
            carteiraDao.alterar(carteira);

            //==============================
            // REGISTRA A TRANSAÇÃO
            //==============================
            Transacao objTransacao = new Transacao();
            objTransacao.setValor(valor);
            objTransacao.setTipo("DEPOSITO");
            objTransacao.setData(data);
            objTransacao.setUsuario(usuario);
            transacaoDao.salvar(objTransacao);

            finalizar(request, response, "Depósito realizado com sucesso!", true);

        } catch (Exception e) {
            finalizar(request, response, "Erro ao realizar depósito: " + e.getMessage(), false);
        }
    }

    private void abrirPagina(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> listaUsuario = usuarioDao.buscarTodosUsuarios();
        request.setAttribute("listaUsuario", listaUsuario);

        List<Carteira> listaCarteira = carteiraDao.buscarTodasCarteiras();
        request.setAttribute("listaCarteira", listaCarteira);

        RequestDispatcher dispatcher
                = request.getRequestDispatcher("/opCarteira.jsp");

        dispatcher.forward(request, response);
    }

    private void cancelar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("usuario", "");
        request.setAttribute("data", "");
        request.setAttribute("valor", "");

        abrirPagina(request, response);

    }
}