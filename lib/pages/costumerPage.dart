import 'package:flutter/material.dart';
import 'package:pdf_reports_dark/models/costumer.dart';
import 'package:pdf_reports_dark/providers/db_provider.dart';

class CostumerPage extends StatefulWidget {
  @override
  _CostumerPageState createState() => _CostumerPageState();
}

class _CostumerPageState extends State<CostumerPage> {
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController nameCtrl = new TextEditingController();

  TextEditingController emailCtrl = new TextEditingController();

  TextEditingController mobileCtrl = new TextEditingController();

  TextEditingController addressdCtrl = new TextEditingController();

  TextEditingController repeatPassCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('Settings', style: TextStyle(color: Colors.white70))),
        ),
        body: ListView(
          padding: EdgeInsets.all(15.0),
          children: [
            Form(key: keyForm, child: formUI()),
            Container(
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.lightBlue[800],
                child: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  save();
                },
              ),
            )
          ],
        ));
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: ListTile(leading: Icon(icon), title: item),
    );
  }

  Widget formUI() {
    return Column(
      children: [
        formItemsDesign(
            Icons.person,
            TextFormField(
              controller: nameCtrl,
              decoration: new InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return validateName.toString();
                } else {
                  return null;
                }
              },
            )),
        formItemsDesign(
            Icons.location_city,
            TextFormField(
              controller: addressdCtrl,
              decoration: new InputDecoration(
                labelText: 'Address',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return validateName.toString();
                } else {
                  return null;
                }
              },
            )),
        formItemsDesign(
            Icons.phone,
            TextFormField(
              controller: mobileCtrl,
              decoration: new InputDecoration(
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value!.isEmpty) {
                  return validateMobile.toString();
                } else {
                  return null;
                }
              },
            )),
        formItemsDesign(
            Icons.email,
            TextFormField(
              controller: emailCtrl,
              decoration: new InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 32,
              validator: (value) {
                if (value!.isEmpty) {
                  return validateEmail.toString();
                } else {
                  return null;
                }
              },
            )),
      ],
    );
  }

  String? validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String? validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "El telefono es necesariod";
    } else if (!regExp.hasMatch(value) || value.length != 10) {
      return "El numero debe tener 10 digitos";
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El correo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "Correo invalido";
    } else {
      return null;
    }
  }

  save() async {
    if (keyForm.currentState!.validate()) {
      final costumer = new CostumerModel(
        //id: 1,
        name: nameCtrl.text.trim(),
        address: addressdCtrl.text.trim(),
        phone: mobileCtrl.text.trim(),
        email: emailCtrl.text.trim(),
      );

      await PdfDatabase.instance.createCostumer(costumer);
      keyForm.currentState!.reset();
    }
  }
}
