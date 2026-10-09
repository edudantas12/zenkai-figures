 
import 'package:flutter/material.dart'; 
 
import '../controller/enderecos_controller.dart'; 
import '../model/enderecos.dart'; 
import '../main.dart'; 
 
class EnderecosPage extends StatefulWidget { 
  final EnderecosController controller; 
 
  const EnderecosPage({ 
    super.key, 
    required this.controller, 
  }); 
 
  @override 
  State<EnderecosPage> createState() => _EnderecosPageState(); 
} 
 
class _EnderecosPageState extends State<EnderecosPage> { 
  @override 
  void initState() { 
    super.initState(); 
    widget.controller.addListener(_atualizar); 
  } 
 
  @override 
  void dispose() { 
    widget.controller.removeListener(_atualizar); 
    super.dispose(); 
  } 
 
  void _atualizar() { 
    if (mounted) setState(() {}); 
  } 
 
  Future<void> _abrirFormulario({Endereco? endereco}) async { 
    final resultado = await Navigator.push<Endereco>( 
      context, 
      MaterialPageRoute( 
        builder: (_) => CadastroEnderecoPage(endereco: endereco), 
      ), 
    ); 
 
    if (resultado == null) return; 
 
    if (endereco == null) { 
      widget.controller.adicionar(resultado); 
    } else { 
      widget.controller.editar(endereco, resultado); 
    } 
  } 
 
  void _confirmarExclusao(Endereco endereco) { 
    showDialog<void>( 
      context: context, 
      builder: (context) => AlertDialog( 
        backgroundColor: panel, 
        title: const Text('Excluir endereço?'), 
        content: const Text( 
          'Deseja realmente remover este endereço?', 
        ), 
        actions: [ 
          TextButton( 
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancelar'), 
          ), 
          TextButton( 
            onPressed: () { 
              widget.controller.excluir(endereco); 
              Navigator.pop(context); 
            }, 
            child: const Text( 
              'Excluir', 
              style: TextStyle(color: Colors.redAccent), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final enderecos = widget.controller.enderecos; 
 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Endereços de entrega'), 
      ), 
      floatingActionButton: FloatingActionButton.extended( 
        backgroundColor: lime, 
        foregroundColor: Colors.black, 
        onPressed: () => _abrirFormulario(), 
        icon: const Icon(Icons.add), 
        label: const Text('Adicionar endereço'), 
      ), 
      body: enderecos.isEmpty 
          ? const Center( 
              child: Padding( 
                padding: EdgeInsets.all(32), 
                child: Text( 
                  'Cadastre seus endereços para agilizar suas compras.', 
                  textAlign: TextAlign.center, 
                  style: TextStyle(color: muted, fontSize: 14), 
                ), 
              ), 
            ) 
          : ListView.separated( 
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), 
              itemCount: enderecos.length, 
              separatorBuilder: (_, index) => 
                  const SizedBox(height: 12), 
              itemBuilder: (context, index) { 
                final endereco = enderecos[index]; 
 
                return Container( 
                  padding: const EdgeInsets.all(16), 
                  decoration: BoxDecoration( 
                    color: panel, 
                    borderRadius: BorderRadius.circular(14), 
                    border: Border.all( 
                      color: endereco.principal ? lime : Colors.white12, 
                    ), 
                  ), 
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [ 
                      Row( 
                        children: [ 
                          const Icon( 
                            Icons.location_on_outlined, 
                            color: lime, 
                          ), 
                          const SizedBox(width: 8), 
                          Expanded( 
                            child: Text( 
                              endereco.destinatario, 
                              style: const TextStyle( 
                                fontWeight: FontWeight.bold, 
                                fontSize: 16, 
                              ), 
                            ), 
                          ), 
                          if (endereco.principal) 
                            const Chip( 
                              label: Text('Principal'), 
                              backgroundColor: lime, 
                              labelStyle: TextStyle(color: Colors.black), 
                              visualDensity: VisualDensity.compact, 
                            ), 
                        ], 
                      ), 
                      const SizedBox(height: 10), 
                      Text( 
                        '${endereco.rua}, ${endereco.numero}', 
                      ), 
                      if (endereco.complemento.isNotEmpty) 
                        Text(endereco.complemento), 
                      Text(endereco.bairro), 
                      Text( 
                        '${endereco.cidade} - ${endereco.estado}', 
                      ), 
                      Text('CEP: ${endereco.cep}'), 
                      const Divider(height: 24), 
                      Wrap( 
                        spacing: 8, 
                        children: [ 
                          TextButton.icon( 
                            onPressed: () => 
                                _abrirFormulario(endereco: endereco), 
                            icon: const Icon(Icons.edit_outlined), 
                            label: const Text('Editar'), 
                          ), 
                          TextButton.icon( 
                            onPressed: () => 
                                _confirmarExclusao(endereco), 
                            icon: const Icon(Icons.delete_outline), 
                            label: const Text('Excluir'), 
                          ), 
                          if (!endereco.principal) 
                            TextButton( 
                              onPressed: () => widget.controller 
                                  .definirPrincipal(endereco), 
                              child: const Text('Tornar principal'), 
                            ), 
                        ], 
                      ), 
                    ], 
                  ), 
                ); 
              }, 
            ), 
    ); 
  } 
} 
 
class CadastroEnderecoPage extends StatefulWidget { 
  final Endereco? endereco; 
 
  const CadastroEnderecoPage({ 
    super.key, 
    this.endereco, 
  }); 
 
  @override 
  State<CadastroEnderecoPage> createState() => 
      _CadastroEnderecoPageState(); 
} 
 
class _CadastroEnderecoPageState extends State<CadastroEnderecoPage> { 
  final _formKey = GlobalKey<FormState>(); 
 
  late final TextEditingController _destinatario; 
  late final TextEditingController _cep; 
  late final TextEditingController _rua; 
  late final TextEditingController _numero; 
  late final TextEditingController _complemento; 
  late final TextEditingController _bairro; 
  late final TextEditingController _cidade; 
  late final TextEditingController _estado; 
 
  bool _principal = false; 
 
  @override 
  void initState() { 
    super.initState(); 
 
    final endereco = widget.endereco; 
 
    _destinatario = 
        TextEditingController(text: endereco?.destinatario ?? ''); 
    _cep = TextEditingController(text: endereco?.cep ?? ''); 
    _rua = TextEditingController(text: endereco?.rua ?? ''); 
    _numero = TextEditingController(text: endereco?.numero ?? ''); 
    _complemento = 
        TextEditingController(text: endereco?.complemento ?? ''); 
    _bairro = TextEditingController(text: endereco?.bairro ?? ''); 
    _cidade = TextEditingController(text: endereco?.cidade ?? ''); 
    _estado = TextEditingController(text: endereco?.estado ?? ''); 
    _principal = endereco?.principal ?? false; 
  } 
 
  @override 
  void dispose() { 
    _destinatario.dispose(); 
    _cep.dispose(); 
    _rua.dispose(); 
    _numero.dispose(); 
    _complemento.dispose(); 
    _bairro.dispose(); 
    _cidade.dispose(); 
    _estado.dispose(); 
    super.dispose(); 
  } 
 
  Widget _campo( 
    String rotulo, 
    TextEditingController controller, { 
    TextInputType tipo = TextInputType.text, 
    bool obrigatorio = true, 
  }) { 
    return TextFormField( 
      controller: controller, 
      keyboardType: tipo, 
      textCapitalization: TextCapitalization.words, 
      decoration: InputDecoration( 
        labelText: rotulo, 
      ), 
      validator: (valor) { 
        if (obrigatorio && (valor == null || valor.trim().isEmpty)) { 
          return 'Preencha este campo'; 
        } 
        return null; 
      }, 
    ); 
  } 
 
  void _salvar() { 
    if (!_formKey.currentState!.validate()) return; 
 
    Navigator.pop( 
      context, 
      Endereco( 
        destinatario: _destinatario.text.trim(), 
        cep: _cep.text.trim(), 
        rua: _rua.text.trim(), 
        numero: _numero.text.trim(), 
        complemento: _complemento.text.trim(), 
        bairro: _bairro.text.trim(), 
        cidade: _cidade.text.trim(), 
        estado: _estado.text.trim(), 
        principal: _principal, 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text( 
          widget.endereco == null 
              ? 'Adicionar endereço' 
              : 'Editar endereço', 
        ), 
      ), 
      body: Form( 
        key: _formKey, 
        child: ListView( 
          padding: const EdgeInsets.all(20), 
          children: [ 
            _campo('Nome do destinatário', _destinatario), 
            const SizedBox(height: 14), 
            _campo( 
              'CEP', 
              _cep, 
              tipo: TextInputType.number, 
            ), 
            const SizedBox(height: 14), 
            _campo('Rua / Avenida', _rua), 
            const SizedBox(height: 14), 
            _campo( 
              'Número', 
              _numero, 
              tipo: TextInputType.number, 
            ), 
            const SizedBox(height: 14), 
            _campo( 
              'Complemento (opcional)', 
              _complemento, 
              obrigatorio: false, 
            ), 
            const SizedBox(height: 14), 
            _campo('Bairro', _bairro), 
            const SizedBox(height: 14), 
            _campo('Cidade', _cidade), 
            const SizedBox(height: 14), 
            _campo('Estado (UF)', _estado), 
            const SizedBox(height: 8), 
            SwitchListTile( 
              contentPadding: EdgeInsets.zero, 
              title: const Text('Definir como principal'), 
              value: _principal, 
              activeThumbColor: lime, 
              onChanged: (valor) { 
                setState(() => _principal = valor); 
              }, 
            ), 
            const SizedBox(height: 20), 
            FilledButton( 
              style: FilledButton.styleFrom( 
                backgroundColor: lime, 
                foregroundColor: Colors.black, 
                padding: const EdgeInsets.symmetric(vertical: 16), 
              ), 
              onPressed: _salvar, 
              child: const Text('Salvar endereço'), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 
