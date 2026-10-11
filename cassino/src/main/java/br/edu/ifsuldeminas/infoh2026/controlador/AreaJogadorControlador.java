package br.edu.ifsuldeminas.infoh2026.controlador;

import br.edu.ifsuldeminas.infoh2026.modelo.dao.ConquistaDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.TransacaoDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioConquistaDAO;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Conquista;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Transacao;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Usuario;
import br.edu.ifsuldeminas.infoh2026.modelo.entidade.UsuarioConquista;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Páginas do jogador logado: /AreaJogador?pagina=transacoes | conquistas
 * Só mostra dados do usuário que está na sessão.
 */
@WebServlet(name = "AreaJogadorControlador", urlPatterns = {"/AreaJogador"})
public class AreaJogadorControlador extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login");
            return;
        }

        String pagina = request.getParameter("pagina");
        if (pagina == null) {
            pagina = "";
        }

        try {
            switch (pagina) {
                case "transacoes":
                    carregarTransacoes(request, usuario);
                    request.setAttribute("areaCarregada", true);
                    request.getRequestDispatcher("/transacoes.jsp").forward(request, response);
                    break;

                case "conquistas":
                    carregarConquistas(request, usuario);
                    request.setAttribute("areaCarregada", true);
                    request.getRequestDispatcher("/conquistas.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/PerfilControlador");
            }
        } catch (Exception e) {
            // Falha de banco etc.: mostra a mensagem na própria página
            request.setAttribute("erro", "Não foi possível carregar os dados: " + e.getMessage());
            request.setAttribute("areaCarregada", true);
            request.getRequestDispatcher(
                    "conquistas".equals(pagina) ? "/conquistas.jsp" : "/transacoes.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void carregarTransacoes(HttpServletRequest request, Usuario usuario) {

        List<Transacao> minhas = new ArrayList<>();
        double totalDepositos = 0;
        double totalSaques = 0;

        // ATENÇÃO: nome do método do DAO supostos pelo padrão dos outros DAOs
        for (Transacao t : new TransacaoDAO().buscarTodasTransacoes()) {
            if (t.getUsuario() != null
                    && Objects.equals(t.getUsuario().getId_usuario(), usuario.getId_usuario())) {
                minhas.add(t);
                Double valorTransacao = t.getValor();
                double v = (valorTransacao != null) ? valorTransacao : 0.0;
                if ("DEPOSITO".equals(t.getTipo())) {
                    totalDepositos += v;
                } else if ("SAQUE".equals(t.getTipo())) {
                    totalSaques += v;
                }
            }
        }

        Collections.reverse(minhas); // mais recentes primeiro

        request.setAttribute("transacoes", minhas);
        request.setAttribute("totalDepositos", totalDepositos);
        request.setAttribute("totalSaques", totalSaques);
    }

    private void carregarConquistas(HttpServletRequest request, Usuario usuario) {

        // id da conquista -> data em que o usuário a desbloqueou
        Map<Integer, Date> desbloqueadas = new HashMap<>();
        for (UsuarioConquista uc : new UsuarioConquistaDAO().buscarTodasUsuarioConquistas()) {
            if (uc.getUsuario() != null && uc.getConquista() != null
                    && Objects.equals(uc.getUsuario().getId_usuario(), usuario.getId_usuario())) {
                desbloqueadas.put(uc.getConquista().getId_conquista(), uc.getData_conquista());
            }
        }

        // ATENÇÃO: nome do método do DAO suposto pelo padrão dos outros DAOs
        List<Conquista> todas = new ConquistaDAO().buscarTodasConquistas();

        request.setAttribute("todasConquistas", todas);
        request.setAttribute("desbloqueadas", desbloqueadas);
        request.setAttribute("qtdDesbloqueadas", desbloqueadas.size());
        request.setAttribute("qtdTotal", todas.size());
        request.setAttribute("percentual",
                todas.isEmpty() ? 0 : (desbloqueadas.size() * 100 / todas.size()));
    }
}