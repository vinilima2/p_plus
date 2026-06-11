import 'package:flutter/material.dart';
import 'package:p_plus/providers/autenticacao_provider.dart';
import 'package:p_plus/services/login_service.dart';
import 'package:p_plus/services/analista_service.dart';
import 'package:p_plus/services/gestor_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool obscurePassword = true;

  void fazerLogin() {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    /// VALIDAÇÃO DOS CAMPOS
    if (email.isEmpty || senha.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Preencha email e senha para continuar.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    LoginService loginService = LoginService();

    loginService
        .login(email, senha)
        .then((dados) {
          if (mounted) {
            if (dados != null) {
              if (dados.tipoUsuario == 'Analista') {
                AnalistaService().obterAnalista(dados.idUsuario ?? '').then((
                  analista,
                ) {
                  if (mounted) {
                    context.read<AutenticacaoProvider>().atualizarDados(
                      token: dados.idUsuario ?? '',
                      nome: analista?.nome ?? 'Analista',
                      email: email,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      'home',
                      (Route<dynamic> route) => false,
                    );
                  }
                });
              } else if (dados.tipoUsuario == 'Gestor') {
                GestorService().obterGestor(dados.idUsuario ?? '').then((
                  gestor,
                ) {
                  if (mounted) {
                    context.read<AutenticacaoProvider>().atualizarDados(
                      token: dados.idUsuario ?? '',
                      nome: gestor?.nome ?? 'Gestor',
                      email: email,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      'gestor',
                      (Route<dynamic> route) => false,
                    );
                  }
                });
              }
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Erro de Autenticação'),
                    content: const Text('E-mail ou senha incorretos.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        })
        .catchError((error) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Erro'),
                  content: Text(error.toString()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 320,

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xFF12B7E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TITULO
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: 300,
                    height: 55,
                    child: TextFormField(
                      maxLength: 255,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        counterText: '',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 300,
                    height: 55,
                    child: TextFormField(
                      maxLength: 255,
                      controller: senhaController,
                      obscureText: obscurePassword,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        counterText: '',
                        hintText: 'Senha',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        prefixIcon: const Opacity(
                          opacity: 0,
                          child: Icon(Icons.visibility),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// BOTAO
                  SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: const BorderSide(color: Colors.black, width: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      onPressed: fazerLogin,

                      child: const Text(
                        'Entrar',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 45),

                  /// LOGO
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 25),
        child: SizedBox(width: 140, child: Image.asset('assets/logo.png')),
      ),
    );
  }
}
