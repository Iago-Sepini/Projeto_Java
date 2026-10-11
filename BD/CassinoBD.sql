-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           12.0.2-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para cassinoonline
DROP DATABASE IF EXISTS `cassinoonline`;
CREATE DATABASE IF NOT EXISTS `cassinoonline` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `cassinoonline`;

-- Copiando estrutura para tabela cassinoonline.aposta
DROP TABLE IF EXISTS `aposta`;
CREATE TABLE IF NOT EXISTS `aposta` (
  `id_aposta` int(11) NOT NULL AUTO_INCREMENT,
  `valor` decimal(10,2) NOT NULL,
  `resultado` varchar(150) NOT NULL,
  `id_partida` int(11) NOT NULL,
  PRIMARY KEY (`id_aposta`),
  KEY `id_partida` (`id_partida`),
  CONSTRAINT `aposta_ibfk_1` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id_partida`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.aposta: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cassinoonline.bonus
DROP TABLE IF EXISTS `bonus`;
CREATE TABLE IF NOT EXISTS `bonus` (
  `id_bonus` int(11) NOT NULL AUTO_INCREMENT,
  `valor` decimal(10,2) NOT NULL,
  `tipo` varchar(150) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_bonus`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `bonus_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.bonus: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cassinoonline.carteira
DROP TABLE IF EXISTS `carteira`;
CREATE TABLE IF NOT EXISTS `carteira` (
  `id_carteira` int(11) NOT NULL AUTO_INCREMENT,
  `saldo` decimal(10,2) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_carteira`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `carteira_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.carteira: ~1 rows (aproximadamente)
INSERT INTO `carteira` (`id_carteira`, `saldo`, `id_usuario`) VALUES
	(4, 1001.00, 2);

-- Copiando estrutura para tabela cassinoonline.conquista
DROP TABLE IF EXISTS `conquista`;
CREATE TABLE IF NOT EXISTS `conquista` (
  `id_conquista` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `recompensa` double DEFAULT NULL,
  PRIMARY KEY (`id_conquista`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.conquista: ~6 rows (aproximadamente)
INSERT INTO `conquista` (`id_conquista`, `nome`, `descricao`, `recompensa`) VALUES
	(4, 'PockerKing', 'ganhe 50 vezes no pocker', 0.9),
	(5, 'Ligeiro', 'roube', 0.5),
	(6, 'Pé Quente', 'realize sua primeira aposta', 0.1),
	(7, 'Mestre dos Giros', 'Completar 100 rodadas em um slot', 0.7),
	(8, 'Guerreiro de Fim de Semana', 'realizar pelo menos 1 jogada na sexta no sabado e domingo', 0.3),
	(9, 'Veterano da Casa', 'completar 2 meses de conta', 0.6);

-- Copiando estrutura para tabela cassinoonline.deposito
DROP TABLE IF EXISTS `deposito`;
CREATE TABLE IF NOT EXISTS `deposito` (
  `id_deposito` int(11) NOT NULL AUTO_INCREMENT,
  `data` datetime NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_deposito`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `deposito_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.deposito: ~2 rows (aproximadamente)
INSERT INTO `deposito` (`id_deposito`, `data`, `valor_total`, `id_usuario`) VALUES
	(5, '2026-10-11 00:00:00', 1.00, 2),
	(6, '2026-10-11 00:00:00', 1000.00, 2);

-- Copiando estrutura para tabela cassinoonline.jogo
DROP TABLE IF EXISTS `jogo`;
CREATE TABLE IF NOT EXISTS `jogo` (
  `id_jogo` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `tipo` varchar(150) NOT NULL,
  `descricao` text NOT NULL,
  PRIMARY KEY (`id_jogo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.jogo: ~3 rows (aproximadamente)
INSERT INTO `jogo` (`id_jogo`, `nome`, `tipo`, `descricao`) VALUES
	(1, 'truco', 'cartas', 'Um clássico jogo de cartas cheio de blefes, estratégia e emoção a cada rodada.'),
	(2, 'Poker', 'cartas', 'Teste sua sorte e habilidade em partidas intensas onde cada decisão pode valer tudo.'),
	(3, 'Roleta', 'Mesa', 'Teste sua sorte e habilidade em partidas intensas onde cada decisão pode valer tudo.');

-- Copiando estrutura para tabela cassinoonline.partida
DROP TABLE IF EXISTS `partida`;
CREATE TABLE IF NOT EXISTS `partida` (
  `id_partida` int(11) NOT NULL AUTO_INCREMENT,
  `data` datetime NOT NULL,
  `resultado` varchar(150) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_jogo` int(11) NOT NULL,
  PRIMARY KEY (`id_partida`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_jogo` (`id_jogo`),
  CONSTRAINT `partida_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `partida_ibfk_2` FOREIGN KEY (`id_jogo`) REFERENCES `jogo` (`id_jogo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.partida: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cassinoonline.saque
DROP TABLE IF EXISTS `saque`;
CREATE TABLE IF NOT EXISTS `saque` (
  `id_saque` int(11) NOT NULL AUTO_INCREMENT,
  `data` datetime NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_saque`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `saque_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.saque: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela cassinoonline.token_recuperacao
DROP TABLE IF EXISTS `token_recuperacao`;
CREATE TABLE IF NOT EXISTS `token_recuperacao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email_usuario` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `data_expiracao` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.token_recuperacao: ~4 rows (aproximadamente)
INSERT INTO `token_recuperacao` (`id`, `email_usuario`, `token`, `data_expiracao`, `usado`) VALUES
	(1, 'iago.sepini@alunos.ifsuldeminas.edu.br', '149249ac-8d87-4226-a32c-bc5903b39f26', '2026-10-11 19:23:53', 0),
	(2, 'iago.sepini@alunos.ifsuldeminas.edu.br', '3add8f4c-0c0a-4899-bfd6-9aac1d474172', '2026-10-11 19:27:18', 0),
	(3, 'iago.sepini@alunos.ifsuldeminas.edu.br', '79d093e4-17fc-4922-bb89-048ce07e2395', '2026-10-11 19:29:23', 0),
	(4, 'iago.sepini@alunos.ifsuldeminas.edu.br', '1f9daf8e-25f7-4d06-84a8-ce298e569448', '2026-10-11 19:34:21', 1);

-- Copiando estrutura para tabela cassinoonline.transacao
DROP TABLE IF EXISTS `transacao`;
CREATE TABLE IF NOT EXISTS `transacao` (
  `id_transacao` int(11) NOT NULL AUTO_INCREMENT,
  `valor` decimal(10,2) NOT NULL,
  `tipo` varchar(150) NOT NULL,
  `data` datetime NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_transacao`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `transacao_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.transacao: ~2 rows (aproximadamente)
INSERT INTO `transacao` (`id_transacao`, `valor`, `tipo`, `data`, `id_usuario`) VALUES
	(11, 1.00, 'DEPOSITO', '2026-10-11 00:00:00', 2),
	(12, 1000.00, 'DEPOSITO', '2026-10-11 00:00:00', 2);

-- Copiando estrutura para tabela cassinoonline.usuario
DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) NOT NULL,
  `senha` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `data_cadastro` date NOT NULL,
  `endereco` varchar(50) NOT NULL,
  `cpf` varchar(50) NOT NULL,
  `data_nascimento` date NOT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.usuario: ~2 rows (aproximadamente)
INSERT INTO `usuario` (`id_usuario`, `nome`, `senha`, `email`, `data_cadastro`, `endereco`, `cpf`, `data_nascimento`) VALUES
	(1, 'Iago', '$2a$10$v4dnp8zFgjPEuac8X4f8c..1YbifoiuQZYJsoWZ7UhtNNeTJKbdHi', 'iago@gmail.com', '2026-10-11', 'rrrrr', '1357123', '2007-02-11'),
	(2, 'Iago22', '$2a$10$h4F11N2pOstut22E.RJ6i.6bvSJodWoAHdlyVTD5w1aLvbQ7mSUqK', 'iago.sepini@alunos.ifsuldeminas.edu.br', '2026-10-11', 'rrrrrrrrr', '123456789', '2026-10-12');

-- Copiando estrutura para tabela cassinoonline.usuario_conquista
DROP TABLE IF EXISTS `usuario_conquista`;
CREATE TABLE IF NOT EXISTS `usuario_conquista` (
  `id_usuarioConquista` int(11) NOT NULL AUTO_INCREMENT,
  `data_conquista` date DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_conquista` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_usuarioConquista`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_conquista` (`id_conquista`),
  CONSTRAINT `usuario_conquista_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `usuario_conquista_ibfk_2` FOREIGN KEY (`id_conquista`) REFERENCES `conquista` (`id_conquista`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela cassinoonline.usuario_conquista: ~1 rows (aproximadamente)
INSERT INTO `usuario_conquista` (`id_usuarioConquista`, `data_conquista`, `id_usuario`, `id_conquista`) VALUES
	(1, '2026-10-11', 2, 4);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
