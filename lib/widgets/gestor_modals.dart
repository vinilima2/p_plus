import 'package:flutter/material.dart';

// ============================================================
// MODAL 1: EXCLUIR MEMBRO DA EQUIPE (Slide 6)
// ============================================================
class ModalExcluirMembro {
  static void mostrar(
    BuildContext context,
    String nomeMembro,
    VoidCallback onConfirmar,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, // Não fecha ao clicar fora
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            // color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Deseja excluir\npermanentemente?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão SIM (verde)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirmar(); // Executa a ação de exclusão
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'SIM',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botão NÃO (vermelho)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'NÃO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MODAL 2: EDITAR CADASTRO (Slide 7)
// ============================================================
class ModalEditarCadastro {
  static void mostrar(
    BuildContext context,
    Map<String, dynamic> membro,
    Function(String, String) onSalvar,
  ) {
    final nomeController = TextEditingController(text: membro['nome']);
    final emailController = TextEditingController(text: membro['email'] ?? '');
    bool ativo = membro['ativo'] ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                //  color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Center(
                    child: Text(
                      'Nome cadastro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo Nome
                  Row(
                    children: [
                      const Text('Nome:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: nomeController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Campo Email
                  Row(
                    children: [
                      const Text('Email:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status (ATIVO/INATIVO)
                  Row(
                    children: [
                      const Text('Status:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            ativo = !ativo;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: ativo ? Colors.green[700] : Colors.red[700],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ativo ? 'ATIVO' : 'INATIVO',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botão Alterar (azul/ciano)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onSalvar(
                            nomeController.text.trim(),
                            emailController.text.trim(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Salvar'),
                      ),
                      const SizedBox(width: 16),
                      // Botão Cancelar (vermelho)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// MODAL 3: BLOQUEAR USUÁRIO COM MOTIVO (Slide 8 - ATUALIZADO)
// ============================================================
class ModalBloquearUsuario {
  static void mostrar(
    BuildContext context,
    String nomeMembro,
    bool estaAtivo,
    Function(String motivo) onBloquear,
  ) {
    // Lista de motivos pré-definidos
    final List<String> motivos = [
      'Férias',
      'Licença Maternidade',
      'Licença Médica',
      'Afastamento',
      'Demissão',
      'Outros',
    ];

    String? motivoSelecionado;

    void habilitarDesabilitarUsuario() {
      if (motivoSelecionado != null || !estaAtivo) {
        Navigator.pop(context);
        onBloquear(motivoSelecionado ?? 'Desbloqueio');
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                //color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    estaAtivo ? 'Desbloquear usuário' : 'Bloquear usuário',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),

                  // Novo status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Novo status:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: estaAtivo
                              ? Colors.red[700]
                              : Colors.green[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          estaAtivo ? 'INATIVO' : 'ATIVO',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ========== CAMPO DE MOTIVO (NOVO!) ==========
                  const Text(
                    'Motivo:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),

                  // Dropdown de motivos
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Selecione um motivo'),
                        value: motivoSelecionado,
                        items: motivos.map((String motivo) {
                          return DropdownMenuItem<String>(
                            value: motivo,
                            child: Text(motivo),
                          );
                        }).toList(),
                        onChanged: (String? novoValor) {
                          setState(() {
                            motivoSelecionado = novoValor;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botão Bloquear (vermelho) - só ativa se selecionar motivo
                  ElevatedButton(
                    onPressed:
                        habilitarDesabilitarUsuario, // Desabilitado se não tiver motivo
                    style: ElevatedButton.styleFrom(
                      backgroundColor: estaAtivo ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: estaAtivo
                          ? Colors.red[400]
                          : Colors.green[400],
                    ),
                    child: Text(
                      estaAtivo ? 'Bloquear' : 'Desbloquear',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// MODAL 4: ALTERAR META DIÁRIA (Slide 9)
// ============================================================
class ModalAlterarMeta {
  static void mostrar(
    BuildContext context,
    int diretasAtual,
    int indiretasAtual,
    Function(int, int) onAlterar,
  ) {
    final diretasController = TextEditingController(
      text: diretasAtual.toString(),
    );
    final indiretasController = TextEditingController(
      text: indiretasAtual.toString(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            //    color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Alterar meta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Diretas
              const Text('Diretas', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: diretasController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              const SizedBox(height: 16),

              // Indiretas
              const Text('Indiretas:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: indiretasController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              const SizedBox(height: 24),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Alterar (azul/ciano)
                  ElevatedButton(
                    onPressed: () {
                      final novasDiretas =
                          int.tryParse(diretasController.text) ?? diretasAtual;
                      final novasIndiretas =
                          int.tryParse(indiretasController.text) ??
                          indiretasAtual;
                      Navigator.pop(context);
                      onAlterar(novasDiretas, novasIndiretas);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Alterar'),
                  ),
                  const SizedBox(width: 16),
                  // Botão Cancelar (vermelho)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MODAL 5: NOVO USUÁRIO (Slide 10)
// ============================================================
class ModalNovoUsuario {
  static void mostrar(
    BuildContext context,
    Function(String, String, String) onCadastrar,
  ) {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            //  color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              const Center(
                child: Text(
                  'Novo usuário',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Nome
              Row(
                children: [
                  const Text('Nome:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Campo Email
              Row(
                children: [
                  const Text('Email:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Campo Senha
              Row(
                children: [
                  const Text('Senha:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Alterar (azul/ciano) - no protótipo está "Alterar", mas é cadastrar
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onCadastrar(
                        nomeController.text.trim(),
                        emailController.text.trim(),
                        senhaController.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Salvar'),
                  ),
                  const SizedBox(width: 16),
                  // Botão Cancelar (vermelho)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MODAL 6: INSERIR AÇÕES VIA PLANILHA (Slide 11)
// ============================================================
class ModalInserirAcoes {
  static void mostrar(BuildContext context, VoidCallback onInserir) {
    String? arquivoSelecionado;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                //   color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Inserir ações',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Área de upload
                  GestureDetector(
                    onTap: () {
                      // Aqui você implementaria o file picker
                      setState(() {
                        arquivoSelecionado = 'planilha_acoes.xlsx';
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          arquivoSelecionado ??
                              'Selecione o arquivo para upload',
                          style: TextStyle(
                            fontSize: 14,
                            color: arquivoSelecionado != null
                                ? Colors.black
                                : Colors.grey[600],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botão Inserir (azul/ciano)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onInserir();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Inserir'),
                      ),
                      const SizedBox(width: 16),
                      // Botão Cancelar (vermelho)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
