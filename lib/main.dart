import 'dart:convert';
import 'package:clima_app/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controladorCidade = TextEditingController();
  GlobalKey<FormState> cForm = GlobalKey<FormState>();
  String cidadeUf = "Cidade:";
  String temperaturaAtual = "";
  String situacao = "Situação:";
  String velocidadeVento = "";
  String dataAmanha = "";
  String diaSemanaAmanha = "";
  String maxAmanha = "Max:";
  String minAmanha = "Min:";
  String situacaoAmanha = "Situação amanhã:";

  Function validaCidade = ((value){
    if(value.isEmpty)
      return "Informe uma cidade";
    return null;
  });

  clicouNoBotao() async{
    if(!cForm.currentState.validate())
      return;

    String cidade = Uri.decodeComponent(controladorCidade.text);
    String url = "https://api.hgbrasil.com/weather?key=0841750e&city_name=$cidade";
    Response resposta = await get(url);
    Map dados = json.decode(resposta.body);
    var resp = dados["results"];
    var forecast = resp["forecast"];
    var amanha = forecast[0];
    setState(() {
      cidadeUf = resp["city"];
      temperaturaAtual = resp["temp"].toString();
      situacao = resp["description"];
      velocidadeVento = resp["wind_speedy"];
      dataAmanha = amanha["date"].toString();
      diaSemanaAmanha = amanha["weekday"];
      minAmanha = amanha["min"].toString();
      maxAmanha = amanha["max"].toString();
      situacaoAmanha = amanha["description"];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: cForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.only(top:20),
                child: Image.asset("assets/imgs/logo.png", fit: BoxFit.contain,),
              ),
              Componentes.caixaDeTexto("Cidade", "Informe a Cidade", controladorCidade, validaCidade),
              Container(
                alignment: Alignment.topCenter,
                height: 100,
                padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
                child: IconButton(
                  onPressed: clicouNoBotao,
                  icon: FaIcon(FontAwesomeIcons.cloudSun, color: Colors.blueAccent, size: 40,),
                ),
              ),

              Componentes.rotulo(cidadeUf),
              Componentes.rotulo("Temperatura agora: " + temperaturaAtual + "°C"),
              Componentes.rotulo(situacao),
              Componentes.rotulo("Velocidade do vento: " + velocidadeVento),
              Divider(color: Colors.black,),
              Componentes.rotulo("Previsão para amanhã"),
              Componentes.rotulo("Data: " + diaSemanaAmanha + " - " + dataAmanha),
              Componentes.rotulo("Min: "+ minAmanha + "°C"),
              Componentes.rotulo("Max: "+ maxAmanha + "°C"),
              Componentes.rotulo(situacaoAmanha),
            ],
          ),
        ),
      ),
    );
  }
}
