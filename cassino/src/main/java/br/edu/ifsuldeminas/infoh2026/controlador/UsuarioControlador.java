package br.edu.ifsuldeminas.infoh2026.controlador;

import br.edu.ifsuldeminas.infoh2026.modelo.entidade.Usuario;
import br.edu.ifsuldeminas.infoh2026.modelo.dao.UsuarioDAO; 
import br.edu.ifsuldeminas.infoh2026.seguranca.Secured;

import org.mindrot.jbcrypt.BCrypt; // Importação da biblioteca de Hash

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/usuarios")
public class UsuarioControlador {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ==========================================
    // 1. ENDPOINTS DE AUTENTICAÇÃO (SESSÃO)
    // ==========================================

    @POST
    @Path("/login")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response login(Usuario credenciais, @Context HttpServletRequest request) {
        try {
            // 1. Busca o usuário apenas pelo E-MAIL
            Usuario user = usuarioDAO.buscarPorEmail(credenciais.getEmail());
            
            // 2. Se o usuário existir, compara a senha digitada com o Hash do banco usando BCrypt
            if (user != null && BCrypt.checkpw(credenciais.getSenha(), user.getSenha())) {
                
                HttpSession session = request.getSession(true);
                user.setSenha(null); // Limpa o hash da memória por segurança
                session.setAttribute("usuarioLogado", user);
                
                return Response.ok("{\"mensagem\": \"Login realizado com sucesso!\"}").build();
            } else {
                return Response.status(Response.Status.UNAUTHORIZED)
                               .entity("{\"erro\": \"E-mail ou senha inválidos.\"}").build();
            }
        } catch (Exception e) {
            return Response.serverError().entity("{\"erro\": \"Erro interno ao tentar logar.\"}").build();
        }
    }

    @POST
    @Path("/logout")
    @Produces(MediaType.APPLICATION_JSON)
    public Response logout(@Context HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return Response.ok("{\"mensagem\": \"Logout realizado com sucesso!\"}").build();
    }


    // ==========================================
    // 2. ENDPOINTS CRUD
    // ==========================================

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response cadastrarUsuario(Usuario novoUsuario) {
        try {
            // Antes de salvar no banco, transformamos a senha em HASH usando BCrypt
            String senhaHash = BCrypt.hashpw(novoUsuario.getSenha(), BCrypt.gensalt());
            novoUsuario.setSenha(senhaHash);
            
            usuarioDAO.salvar(novoUsuario);
            return Response.status(Response.Status.CREATED)
                           .entity("{\"mensagem\": \"Usuário cadastrado com sucesso!\"}").build();
        } catch (Exception e) {
            return Response.serverError().entity("{\"erro\": \"Erro ao cadastrar usuário.\"}").build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Secured 
    public Response listarUsuarios() {
        try {
            List<Usuario> usuarios = usuarioDAO.buscarTodosUsuarios();
            
            for(Usuario u : usuarios) {
                u.setSenha(null); 
            }
            
            return Response.ok(usuarios).build();
        } catch (Exception e) {
            return Response.serverError().entity("{\"erro\": \"Erro ao buscar usuários.\"}").build();
        }
    }

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Secured 
    public Response buscarPorId(@PathParam("id") int id) {
        try {
            Usuario usuario = usuarioDAO.buscarUsuarioPorId(id);
            if (usuario != null) {
                usuario.setSenha(null);
                return Response.ok(usuario).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                               .entity("{\"erro\": \"Usuário não encontrado.\"}").build();
            }
        } catch (Exception e) {
            return Response.serverError().entity("{\"erro\": \"Erro ao buscar usuário.\"}").build();
        }
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Secured 
    public Response atualizarUsuario(@PathParam("id") int id, Usuario usuarioAtualizado) {
        try {
            Usuario usuarioExistente = usuarioDAO.buscarUsuarioPorId(id);
            if (usuarioExistente == null) {
                return Response.status(Response.Status.NOT_FOUND)
                               .entity("{\"erro\": \"Usuário não encontrado para edição.\"}").build();
            }
            
            // Se o usuário mandou uma senha nova, gera o hash dela. 
            // Caso contrário, mantém a senha hash antiga.
            if(usuarioAtualizado.getSenha() != null && !usuarioAtualizado.getSenha().isEmpty()) {
                String senhaHash = BCrypt.hashpw(usuarioAtualizado.getSenha(), BCrypt.gensalt());
                usuarioAtualizado.setSenha(senhaHash);
            } else {
                usuarioAtualizado.setSenha(usuarioExistente.getSenha());
            }
            
            usuarioAtualizado.setId_usuario(id);
            usuarioDAO.alterar(usuarioAtualizado);
            
            return Response.ok("{\"mensagem\": \"Usuário atualizado com sucesso!\"}").build();
        } catch (Exception e) {
            return Response.serverError().entity("{\"erro\": \"Erro ao atualizar usuário.\"}").build();
        }
    }

    @DELETE
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    @Secured 
    public Response deletarUsuario(@PathParam("id") int id) {
        try {
            Usuario usuario = usuarioDAO.buscarUsuarioPorId(id);
            if (usuario != null) {
                usuarioDAO.excluir(usuario); // Ajustado para passar o objeto inteiro, conforme seu DAO
                return Response.ok("{\"mensagem\": \"Usuário excluído com sucesso!\"}").build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                               .entity("{\"erro\": \"Usuário não encontrado para exclusão.\"}").build();
            }
        } catch (Exception e) {
            return Response.serverError().entity("{\"erro\": \"Erro ao excluir usuário.\"}").build();
        }
    }
}