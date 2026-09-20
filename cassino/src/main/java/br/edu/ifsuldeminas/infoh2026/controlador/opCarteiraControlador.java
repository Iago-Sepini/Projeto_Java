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
import java.sql.Date;
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

    private Saque objSaque;
    private Transacao objTransacao;

    @Override
    public void init() throws ServletException {

        saqueDao = new SaqueDAO();
        depositoDao = new DepositoDAO();
        carteiraDao = new CarteiraDAO();
        transacaoDao = new TransacaoDAO();
        usuarioDao = new UsuarioDAO();

        objSaque = new Saque();
        objTransacao = new Transacao();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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
///////////////////////////////////////////// SAQUE /////////////////////////////////////////////////////////////////////////
    private void realizarSaque(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Integer idUsuario
                    = Integer.valueOf(request.getParameter("usuario"));

            Double valor
                    = Double.valueOf(request.getParameter("valor"));

            Date data
                    = Date.valueOf(request.getParameter("data"));

            Usuario usuario
                    = usuarioDao.buscarUsuarioPorId(idUsuario);

            if (usuario == null) {

                request.setAttribute("mensagem",
                        "Usuário não encontrado.");

                abrirPagina(request, response);
                return;

            }

            Carteira carteira
                    = carteiraDao.buscarCarteiraPorUsuario(idUsuario);

            if (carteira == null) {

                request.setAttribute("mensagem",
                        "Carteira não encontrada.");

                abrirPagina(request, response);
                return;

            }

            if (carteira.getSaldo() < valor) {

                request.setAttribute("mensagem",
                        "Saldo insuficiente.");

                abrirPagina(request, response);
                return;

            }

            //==============================
            // SALVA O SAQUE
            //==============================
            objSaque = new Saque();

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
            objTransacao = new Transacao();

            objTransacao.setValor(valor);
            objTransacao.setTipo("SAQUE");
            objTransacao.setData(data);
            objTransacao.setUsuario(usuario);

            transacaoDao.salvar(objTransacao);

            request.setAttribute("mensagem",
                    "Saque realizado com sucesso!");

        } catch (Exception e) {

            request.setAttribute("mensagem",
                    "Erro ao realizar saque: "
                    + e.getMessage());

        }

        abrirPagina(request, response);

    }
///////////////////////////////////////////// DEPÓSITO /////////////////////////////////////////////////////////////////////////
    private void realizarDeposito(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer idUsuario = Integer.valueOf(request.getParameter("usuario"));
            Double valor = Double.valueOf(request.getParameter("valor"));
            Date data = Date.valueOf(request.getParameter("data"));

            Usuario usuario = usuarioDao.buscarUsuarioPorId(idUsuario);
            if (usuario == null) {
                request.setAttribute("mensagem", "Usuario nao encontrado.");
                abrirPagina(request, response);
                return;
            }

            Carteira carteira = carteiraDao.buscarCarteiraPorUsuario(idUsuario);
            if (carteira == null) {
                request.setAttribute("mensagem", "Carteira nao encontrada.");
                abrirPagina(request, response);
                return;
            }

            //==============================
            // SALVA O DEPOSITO
            //==============================
            Deposito objDeposito = new Deposito();
            objDeposito.setData(data);
            objDeposito.setValor_total(valor); // Ajuste de acordo com o set da entidade Deposito
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
            objTransacao = new Transacao();
            objTransacao.setValor(valor);
            objTransacao.setTipo("DEPOSITO");
            objTransacao.setData(data);
            objTransacao.setUsuario(usuario);
            transacaoDao.salvar(objTransacao);

            request.setAttribute("mensagem", "Deposito realizado com sucesso!");

        } catch (Exception e) {
            request.setAttribute("mensagem", "Erro ao realizar deposito: " + e.getMessage());
        }

        abrirPagina(request, response);
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
