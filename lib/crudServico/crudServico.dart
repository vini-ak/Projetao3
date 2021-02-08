import 'package:Projetao3/crudServico/crudServicosArgs.dart';
import 'package:Projetao3/infrastructure/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_widgets/oiaWidgets.dart';
import '../infrastructure/cartaServico.dart';
import '../infrastructure/imageProvider.dart';
import '../infrastructure/loginAuth.dart';

class CrudServico extends StatefulWidget {
  @override
  _CrudServicoState createState() => _CrudServicoState();
}

class _CrudServicoState extends State<CrudServico> {
  CartaServicos _cartaServicos;
  String _tipo, uid;
  Future<List> _imagens;
  Servico _servico;
  LoginAuth auth = Authentication.loginAuth;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _valorMedioController;
  TextEditingController _descricaoController;

  final imageProvider = OiaImageProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.authChangeListener();
    uid = auth.getUid();
    setState(() {
      _imagens = Future.delayed(Duration(seconds: 4),
          () => imageProvider.getAllImagesOfAService(uid, _tipo));
    });
  }

  @override
  Widget build(BuildContext context) {
    CrudServicoArgs args = ModalRoute.of(context).settings.arguments;
    setState(() {
      _cartaServicos = args.cartaServicos;
      _tipo = args.tipo;

      // Recuperando as informações do Servico
      // _servico = _cartaServicos.getServico(_tipo);

      // Map servicoData = _servico.toJson();
      // num valorMedio = servicoData["valorMedio"];

      // _valorMedioController =
      //     TextEditingController(text: valorMedio.toString());
    });

    return OiaScaffold(
      appBarTitle: _tipo,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Constants.LARGE_HEIGHT_BOX,
            Text(
              _tipo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Constants.mediumFontSize,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            Text(
              "Adicione informações sobre o serviço abaixo. Fale um pouco sobre a sua experiência, preço dos serviços, formas de pagamento e regiões onde você atua.",
              textAlign: TextAlign.justify,
            ),
            Constants.LARGE_HEIGHT_BOX,
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                labelText: "Valor Médio (R\$)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(Constants.smallSpace),
              child: Column(
                children: [
                  Constants.MEDIUM_HEIGHT_BOX,
                  Text(
                    "Imagens",
                    style: TextStyle(
                      fontSize: Constants.regularFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Constants.SMALL_HEIGHT_BOX,
                  Text("Adicione as imagens do serivço abaixo:"),
                  Constants.MEDIUM_HEIGHT_BOX,
                  TextButton.icon(
                      onPressed: () {
                        Future<String> imageURL = imageProvider.sendImage(
                            ImageSource.camera, _tipo, uid);
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Adicionar imagem")),
                  Constants.MEDIUM_HEIGHT_BOX,
                  FutureBuilder<List<dynamic>>(
                      future: _imagens,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            print("Snapshot data: ${snapshot.data}");
                            return GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: List.generate(snapshot.data.length,
                                    (index) {
                                  String imageURL = snapshot.data[index];

                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(imageURL),
                                      ),
                                    ),
                                  );
                                }));
                            break;
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      })
                ],
              ),
            ),
            Constants.MEDIUM_HEIGHT_BOX,
            OiaLargeButton(
              title: "Salvar",
              onPressed: () {
                Navigator.pushNamed(context, '/profile',
                    arguments: _cartaServicos);
              },
            ),
            Constants.LARGE_HEIGHT_BOX,
          ],
        ),
      ),
    );
  }
}
