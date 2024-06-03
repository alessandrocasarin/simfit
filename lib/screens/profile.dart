import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController datemsController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int? bs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970, 1),
      lastDate: DateTime(2024, 12));
    if (picked != null && picked != selectedDate) {
      String picked_date = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = picked_date;
    }
  }
  
  Future<void> _selectDate_ms(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970, 1),
      lastDate: DateTime(2024, 12));
    if (picked != null && picked != selectedDate) {
      String picked_date = DateFormat('yyyy-MM-dd').format(picked);
      datemsController.text = picked_date;
    }
  }

  void _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    // Use a default value if the key doesn't exist
    String bioS = sp.getString('bs') ?? "";
    String dob = sp.getString('dob') ?? "";
    String ms_start = sp.getString('ms_start') ?? "";
    String name = sp.getString('name') ?? "";
    setState(() {
      bs = int.tryParse(bioS);
      dateController.text = dob;
      datemsController.text = ms_start;
      nameController.text = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Profile',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blue),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:100),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final sp = await SharedPreferences.getInstance();
                          await sp.setString('bs', bs.toString());
                          if(sp.getString('bs')==0){
                            await sp.setString('gender', 'male');
                          }else{
                            await sp.setString('gender', 'female');
                          }
                          await sp.setString('dob', dateController.text);
                          await sp.setString('ms_start', datemsController.text);
                          await sp.setString('name', nameController.text.toString());
                          Navigator.of(context).pop();
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                      child: const Text('Save',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]
                ),

              Padding(
                padding: const EdgeInsets.only(right: 20, top: 30),
                child: const Text(
                  'About you',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
              ),
              ),        
             
              
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.blue
                    ),
                    hintText: 'Name',
                  ),
                ),
              ),
              
              
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8.0),
                child: TextFormField(
                  onTap: () {
                    _selectDate(context);
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Date of Birth is required';
                    }
                    return null;
                  },
                  controller: dateController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: Colors.blue
                    ),
                    hintText: 'Date of Birth',
                  ),
                ),
              ),
              
              
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8.0),
                child: Container(
                  height:65,
                  child:DropdownButtonFormField(
                    isDense: false,
                    itemHeight: 50,  
                    value: bs,
                    validator: (value) {
                      if (value == null) {
                        return 'Biological Sex is required';
                      }
                      return null;
                    },
                    alignment: AlignmentDirectional.centerStart,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    hint: Row(children: [
                      Icon(MdiIcons.genderMaleFemale,color: Colors.blue, size: 27),
                      Text("  Biological Sex",
                        style: TextStyle(
                          fontSize:16
                        )
                      )
                    ]),
                    items: [
                      DropdownMenuItem(
                        child: Row(children: [
                          Icon(MdiIcons.genderMale,color: Colors.blue, size: 27), Text('  male')]),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Row(
                          children: [
                            Icon(MdiIcons.genderFemale,color: Colors.blue, size: 27), 
                            Text('  female'),
                          ],
                        ),
                        value: 1
                      )
                    ],
                    onChanged: (value) {
                      bs = value ?? bs;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              
              
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 30),
                child: const Text(
                  'About the simulation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8.0),
                child: TextFormField(
                  onTap: () {
                    _selectDate_ms(context);
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Date of mesocycle start is required';
                    }
                    return null;
                  },
                  controller: datemsController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))),
                    prefixIcon: const Icon(
                      Icons.play_circle,
                      color: Colors.blue,
                      size:28
                    ),
                    hintText: 'Date of mesocycle start',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
