import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_tracking_app/Repository/driveRepository.dart';

import '../../Repository/firebaseRepository.dart';
import '../common/custom_input_field.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _agreePersonalData = true;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  late DriveRepository driveRepository;
  late dynamic driveApi;
  late String folderId;
  RxBool isLoading = false.obs;

  initState() {
    super.initState();
    getData();
  }

  // Future<String> loadAsset(String path) async {
  //   return await rootBundle.loadString(path);
  // }

  getData() async {
    const serviceAccountKey = '''{
  "type": "service_account",
  "project_id": "dulcet-bucksaw-445110-g0",
  "private_key_id": "7569bc919a316305387ef735eb2be7d3aff54bad",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCyIMJlX6awcC03\\nGhTXDXKG53zIgGzAdE26MjLhBBjyXBflBUBt+QoKmRfEgdqjkDDIGUEBU7RCrSd1\\n6BVP8DFXxG/pMFlKE66iAhAVCgM51Y1xriMOXV7sez03S9Wk5tCys51QAqRHbFZ1\\nPQY1r8g9GYC4hlfu7FQ15FXzlmkmwt5cjXrMGZTTtrPV0n9VgLXrlVtTmYn9TI7F\\nFnRS0ppM+ONuifw0h1EKnGilYjDblJyzIPUUuv5SdMT4doz+wysqJY+XpGYm0fA7\\nuaYSeR7mgxWLe4nTdK91B7gS6XV1vKOktk9O/Rg+t0CbRVxP+wOjwElCcbeK7r00\\nhQtD4IhvAgMBAAECggEAIoUHtzaQqpuqn4WN6VkhSzR8Maz1plxDneRRiNrO7NTd\\nCpR4dndvMzuU6A+UK+NrGLQQLW4nvk4pGgfmbW3qWgxm9aVZgGoNCzdkH3enxWL1\\nvMSW5ZdBqIl/hQJMvl6+rgrx3woMBQ1hOeogFHJi1zhkgh4C13n0HdeIsqKA8TI6\\nQ1criGNq+6GqWHnIXbvqiQrClS4WspnaY6zoz3lDXYVrq2UfQSvTSEoU93VFxSew\\njKIc4O6d1gqvBX9GrQrfXHChykABA/hPTLuRlq7Wo/4eXs/JmQO1L8DvOl2mpt96\\n2tQCyG4ifAOCpncds3FjBIfNYlwjCdEj4sWnu9xJ6QKBgQDtYTImdks+Xld3hBOt\\n8fDSkV2WJeF8tTSlP7zLh2FrVo7HQvfVCByYDujGfVzaBkLeea5LHS4IBhkEI/CS\\nVApKKuUcdPGraH+4izygRHU9WUIlVuZpD1mZ+sdb/k3Ml2UapxzzwpV9ugF2PWN6\\nB2GTcj43CLOkAYluo3p+k/H0OQKBgQDAGbv2kKoeZticDPfavcSDA63iyjtvhX/u\\nU+PIiKQxdM0dp8pq2o8YpQAc4Se7Yukn7fzy2kiBLLZGkO6WwPv47UWqaunkmW2I\\n1Eyj4OSzxO5o1aGbV8R8mZUhBoLJMwmlJK+B8CRDBnqeAy6WOzGC3DLTr6ifH2iE\\njtp3NcBx5wKBgE7lXRu3eW6zQHLyrO/FV/tEYUyELpuaRnMd6gvjZRed3zqPIXvm\\nhEptuiQuimvUZOk4nBtPCXuVOz9LCqw3zmu0Mg3xOFl2E+0sKexClIzdW8S5Sz9j\\n4K3y0cvbi9QSBYKERHUoGTN+XPoFkUh/p4iwEcmM1NgPwrPJFe94EJTRAoGAeMX1\\nIZBUFCcO2hVhIpoaWVBP23zPn06sXrdJR0N5D0rixlk+bq2YN6NNDdsUsr/93EfI\\ntxo7aVMmCfmGtyr/f8IVAY6UHE/FyLfIs2NqBgey6CAfqV2lv7yDQK8qPLqkvrnw\\nyd2jvqvtHTjc6kCu4Rn1rpcKiXgiquxxN2+I3VMCgYAYpNhxle6VDgYROwtQfYjz\\nrawrwOS22Zm0gxFBnp4qWgyABHr+as6p4jyypnaDGFLlvgaCtEJWt8UTOlNBGSvO\\n2qnxc9Vk+1n6Fg/1uAjwHj224iUyKURFwM+im5v7vLoCK8//Z9p04I5vgFBRHHva\\n45phicwMwI5fv0ypKABV6g==\\n-----END PRIVATE KEY-----\\n",
  "client_email": "profile-image-uploader@dulcet-bucksaw-445110-g0.iam.gserviceaccount.com",
  "client_id": "116108050047817004671",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/profile-image-uploader%40dulcet-bucksaw-445110-g0.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
    driveRepository = DriveRepository(serviceAccountKey);
    driveApi = await driveRepository.authenticateServiceAccount();
    folderId = await driveRepository.getOrCreateFolder(driveApi);
    print("AAAAA ${folderId.toString()}");
  }

  Future<void> _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() => _profileImage = File(image.path));
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future<void> _handleSignupUser({String profileURL = ""}) async {
    if (_signupFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitting data...')),
      );

      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String contact = _contactController.text.trim();
      String password = _passwordController.text.trim();

      String? errorMessage =
          await _firebaseRepository.createUserWithEmailAndPassword(
              email, password, name, contact, profileURL);

      if (errorMessage == null) {
        // Successfully signed up
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Successful!')),
        );

        // Navigate to the LoginPage
        Get.off(const LoginPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          const Spacer(flex: 1),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _signupFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff520521)),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: _pickProfileImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey.shade700)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      CustomInputField(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      CustomInputField(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      CustomInputField(
                        labelText: 'Contact Number',
                        hintText: 'Enter your contact number',
                        controller: _contactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact Number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      CustomInputField(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() => _agreePersonalData = value!);
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to the processing of personal data',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xff520521), // Button background color
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: for rounded corners
                            ),
                          ),
                          onPressed: () async {
                            if (_signupFormKey.currentState!.validate() &&
                                _agreePersonalData) {
                              isLoading.value = true;
                              try {
                                if (_profileImage == null) {
                                  await _handleSignupUser();
                                } else {
                                  String url =
                                      await driveRepository.uploadImageToFolder(
                                          driveApi,
                                          folderId,
                                          _profileImage!,
                                          _emailController.text);
                                  await _handleSignupUser(profileURL: url);
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            } else if (!_agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please agree to the terms'),
                                ),
                              );
                            }
                          },
                          child: Obx(
                            () => isLoading.value == true
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Sign Up'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xff520521),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
