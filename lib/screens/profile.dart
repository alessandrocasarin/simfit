import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/providers/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateBirthController = TextEditingController();
  final TextEditingController dateMesoController = TextEditingController();
  final TextEditingController durationMesoController = TextEditingController();
  late UserProvider _userProvider;

  DateTime selectedDate = DateTime.now();
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970, 1),
      lastDate: DateTime(2024, 12),
    );
    if (picked != null && picked != selectedDate) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _loadUserInfo() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _gender = _userProvider.gender ?? 'male';
      dateBirthController.text = _userProvider.birthDate != null
          ? DateFormat('yyyy-MM-dd').format(_userProvider.birthDate!)
          : '';
      dateMesoController.text = _userProvider.mesocycleStartDate != null
          ? DateFormat('yyyy-MM-dd').format(_userProvider.mesocycleStartDate!)
          : '';
      nameController.text = _userProvider.name ?? '';
      durationMesoController.text = _userProvider.mesocycleLength?.toString() ?? '';
    });
  }

  void _saveUserInfo() {
    if (_formKey.currentState!.validate()) {
      _userProvider.setUserData(
        newName: nameController.text,
        newGender: _gender,
        newBirthDate: dateBirthController.text,
        newMesoLength: int.parse(durationMesoController.text),
        newMesoStart: dateMesoController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Information saved correctly!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade50,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          prefixIcon: Icon(icon, color: Colors.blue, size: 30),
          hintText: hintText,
        ),
        validator: validator,
        onTap: onTap,
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _saveUserInfo,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text(
                      'Save',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'About you',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              _buildTextFormField(
                controller: nameController,
                hintText: 'Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length > 20) {
                    return 'Name can have max 20 characters';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: dateBirthController,
                hintText: 'Date of Birth',
                icon: Icons.calendar_month_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of Birth is required';
                  }
                  int year = int.parse(value.substring(0, 4));
                  if (year < (DateTime.now().year - 100) ||
                      year > (DateTime.now().year - 12)) {
                    return 'Year of birth must be ${(DateTime.now().year - 100)} - ${(DateTime.now().year - 12)}';
                  }
                  return null;
                },
                onTap: () => _selectDate(context, dateBirthController),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 8.0),
                child: Container(
                  height: 65,
                  child: DropdownButtonFormField(
                    isDense: false,
                    itemHeight: 50,
                    value: _gender,
                    validator: (value) {
                      if (value == null) {
                        return 'Biological Sex is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'male',
                        child: Row(
                          children: [
                            Icon(MdiIcons.genderMale,
                                color: Colors.blue, size: 35),
                            Text('  male',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Row(
                          children: [
                            Icon(MdiIcons.genderFemale,
                                color: Colors.blue, size: 35),
                            Text('  female',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value ?? _gender;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(right: 20, top: 15),
                child: Text(
                  'About the simulation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              _buildTextFormField(
                controller: durationMesoController,
                hintText: 'Mesocycle duration (days)',
                icon: Icons.av_timer,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mesocycle duration is required';
                  }
                  int duration = int.parse(value);
                  if (duration > 100 || duration < 14) {
                    return 'Mesocycle duration must be 14-100 days';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                controller: dateMesoController,
                hintText: 'Date of mesocycle start',
                icon: Icons.play_arrow_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of mesocycle start is required';
                  }
                  int duration = int.parse(durationMesoController.text);
                  DateTime startDate = DateTime.parse(value);
                  if (startDate.isAfter(
                          DateTime.now().subtract(const Duration(days: 1))) ||
                      startDate.isBefore(DateTime.now()
                          .subtract(Duration(days: duration + 2)))) {
                    String y = DateTime.now()
                        .subtract(const Duration(days: 1))
                        .toString()
                        .substring(0, 10);
                    String d = DateTime.now()
                        .subtract(Duration(days: duration + 1))
                        .toString()
                        .substring(0, 10);
                    return 'Must be from $d to $y';
                  }
                  return null;
                },
                onTap: () => _selectDate(context, dateMesoController),
              ),
            ],
          ),
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
