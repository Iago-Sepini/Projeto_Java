/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.edu.ifsuldeminas.infoh2026.controlador;

import br.edu.ifsuldeminas.infoh2026.modelo.dao.TransacaoDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioDAO;
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
 * @author 12409864678
 */
@WebServlet(WebConstante.BASE_PATH + "/TransacaoControlador")
public class TransacaoControlador extends HttpServlet {

    Transacao objTransacao;
    UsuarioDAO objUsuarioDao;
    TransacaoDAO objTransacaoDao;

    String idTransacao = "";
    String valorTransacao = "";
    String tipoTransacao = "";
    String dataTransacao = "";
    String usuarioTransacao = "";
    String opcao = "";

    @Override
    public void init() throws ServletException {

        objUsuarioDao = new UsuarioDAO();
        objTransacao = new Transacao();
        objTransacaoDao = new TransacaoDAO();

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            opcao = request.getParameter("opcao");

            if (opcao == null || opcao.isEmpty()) {
                opcao = "cadastrar";
            }

            idTransacao = request.getParameter("idTransacao");
            valorTransacao = request.getParameter("valorTransacao");
            tipoTransacao = request.getParameter("tipoTransacao");
            dataTransacao = request.getParameter("dataTransacao");
            usuarioTransacao = request.getParameter("usuarioTransacao");

            switch (opcao) {

                case "cadastrar":
                    cadastrar(request, response);
                    break;

                case "enviarAlterar":
                    enviarAlterar(request, response);
                    break;

                case "enviarExcluir":
                    enviarExcluir(request, response);
                    break;

                case "confirmarAlterar":
                    confirmarAlterar(request, response);
                    break;

                case "confirmarExcluir":
                    confirmarExcluir(request, response);
                    break;

                case "cancelar":
                    cancelar(request, response);
                    break;

                default:
                    throw new IllegalArgumentException(
                            "Opção inválida " + opcao);

            }

        } catch (NumberFormatException e) {

            response.getWriter().println(
                    "Erro: um ou mais parâmetros não são números válidos. "
                    + e.getMessage());

        } catch (IllegalArgumentException e) {

            response.getWriter().println("Erro: " + e.getMessage());

        }

    }

    private void cadastrar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        objTransacao.setValor(
                Double.valueOf(valorTransacao));

        objTransacao.setTipo(tipoTransacao);

        objTransacao.setData(
                Date.valueOf(dataTransacao));

        objTransacao.getUsuario().setId_usuario(
                Integer.valueOf(usuarioTransacao));

        objTransacaoDao.salvar(objTransacao);

        request.setAttribute(
                "mensagem",
                "Transação cadastrada com sucesso!");

        encaminharParaPagina(request, response);

    }

    private void enviarAlterar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "idTransacao", idTransacao);

        request.setAttribute(
                "valorTransacao", valorTransacao);

        request.setAttribute(
                "tipoTransacao", tipoTransacao);

        request.setAttribute(
                "dataTransacao", dataTransacao);

        request.setAttribute(
                "usuarioTransacao", usuarioTransacao);

        request.setAttribute(
                "opcao", "confirmarAlterar");

        request.setAttribute(
                "mensagem",
                "Edite os dados e clique em Salvar");

        encaminharParaPagina(request, response);

    }

    private void enviarExcluir(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "idTransacao", idTransacao);

        request.setAttribute(
                "valorTransacao", valorTransacao);

        request.setAttribute(
                "tipoTransacao", tipoTransacao);

        request.setAttribute(
                "dataTransacao", dataTransacao);

        request.setAttribute(
                "usuarioTransacao", usuarioTransacao);

        request.setAttribute(
                "opcao", "confirmarExcluir");

        request.setAttribute(
                "mensagem",
                "Confirme os dados e clique em Salvar para excluir");

        encaminharParaPagina(request, response);

    }

    private void confirmarAlterar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        objTransacao.setId_transacao(
                Integer.valueOf(idTransacao));

        objTransacao.setValor(
                Double.valueOf(valorTransacao));

        objTransacao.setTipo(tipoTransacao);

        objTransacao.setData(
                Date.valueOf(dataTransacao));

        objTransacao.getUsuario().setId_usuario(
                Integer.valueOf(usuarioTransacao));

        objTransacaoDao.alterar(objTransacao);

        encaminharParaPagina(request, response);

    }

    private void confirmarExcluir(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        objTransacao.setId_transacao(
                Integer.valueOf(idTransacao));

        objTransacaoDao.excluir(objTransacao);

        encaminharParaPagina(request, response);

    }

    private void encaminharParaPagina(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> listaUsuario =
                objUsuarioDao.buscarTodosUsuarios();

        request.setAttribute(
                "listaUsuario",
                listaUsuario);

        List<Transacao> listaTransacao =
                objTransacaoDao.buscarTodasTransacoes();

        request.setAttribute(
                "listaTransacao",
                listaTransacao);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher(
                        "/CadastroTransacao.jsp");

        dispatcher.forward(request, response);

    }

    private void cancelar(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "idTransacao", "0");

        request.setAttribute(
                "valorTransacao", "");

        request.setAttribute(
                "tipoTransacao", "");

        request.setAttribute(
                "dataTransacao", "");

        request.setAttribute(
                "usuarioTransacao", "");

        request.setAttribute(
                "opcao", "cadastrar");

        encaminharParaPagina(request, response);

    }
}