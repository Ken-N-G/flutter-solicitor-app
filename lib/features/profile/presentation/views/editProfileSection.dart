import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/profile/domain/profileProvider.dart';
import 'package:jobs_r_us/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customTextFormField.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class EditProfileSection extends StatefulWidget {
  const EditProfileSection({super.key});

  @override
  State<EditProfileSection> createState() => _EditProfileSectionState();
}

class _EditProfileSectionState extends State<EditProfileSection> with WidgetsBindingObserver {
  late ScrollController scrollController;
  
  DateTime? dateOfBirth;

  DateFormat formatter = DateFormat("d MMM yyyy");

  late bool _hideSaveButton;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController placeOfResidenceController;
  late TextEditingController dateOfBirthController;
  File? selectedFile;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    _hideSaveButton = false;
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    placeOfResidenceController = TextEditingController();
    dateOfBirthController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      fullNameController.text = profileProvider.userProfile!.fullName;
      phoneController.text = profileProvider.userProfile!.phoneNumber;
      placeOfResidenceController.text = profileProvider.userProfile!.placeOfResidence;
      emailController.text = profileProvider.userProfile!.email;
      dateOfBirth = profileProvider.userProfile!.dateOfBirth;
      dateOfBirthController.text = formatter.format(profileProvider.userProfile!.dateOfBirth);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    placeOfResidenceController.dispose();
    dateOfBirthController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    setState(() {
      if (View.of(context).viewInsets.bottom > 0.0) {
        _hideSaveButton = true;
      } else {
        _hideSaveButton = false;
      }
    });
  }

  Widget _setProfilePicture(String? profileUrl, File? profileFile, BuildContext context) {
    if (profileFile != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        width: 120,
        height: 120,
        child: Image.file(
          profileFile,
          fit: BoxFit.cover,
        ),
      );
    } else if (profileUrl!.isNotEmpty) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        width: 120,
        height: 120,
        child: Image.network(
          profileUrl,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Ink(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle
        ),
        child: Icon(
          Icons.person_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
          size: 64,
        ),
      );
    }
  }

  void _showDateTime() {
    showDatePicker(
      context: context, 
      initialDate: (dateOfBirth != null) ? dateOfBirth : DateTime.now(),
      firstDate: DateTime(120), 
      lastDate: DateTime.now()
    ).then((value) => setState(() {
      dateOfBirth = value;
      if (dateOfBirth != null) {
        dateOfBirthController.text = formatter.format(dateOfBirth!);
      } else {
        dateOfBirthController.text = "";
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    
    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Edit Profile",
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 5,),

                          InkWell(
                            onTap: () async {
                              selectedFile = await profileProvider.getImageFromGallery(context);
                              setState(() {
                                
                              });
                            },
                            child: _setProfilePicture(profileProvider.userProfile?.profileUrl, selectedFile, context)
                          ),

                          const SizedBox(height: 30,),
                      
                          CustomTextFormField(
                            keyboardInput: TextInputType.name,
                            controller: fullNameController,
                            validator: (name) => authProvider.validateFullName(name!.trim()),
                            label: "Full Name"
                          ),
                      
                          const SizedBox(height: 10),
                      
                          CustomFieldButton(
                            label: "Date of Birth",
                            controller: dateOfBirthController,
                            validator: (dateOfBirth) => authProvider.validateDateOfBirth(dateOfBirth),
                            defaultInnerLabel: (dateOfBirthController.text.isNotEmpty) ? formatter.format(dateOfBirth!) : "- Select date -",
                            suffixIcon: const Icon(
                              Icons.calendar_month_rounded
                            ),
                            onFieldTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _showDateTime();
                            },
                          ),

                          const SizedBox(height: 10),

                          CustomTextFormField(
                            keyboardInput: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (email) => authProvider.validateEmail(email!.trim()),
                            label: "Email"
                          ),
                                  
                          const SizedBox(height: 10),
                      
                          CustomTextFormField(
                            prefixLabel: "+62",
                            keyboardInput: TextInputType.phone,
                            controller: phoneController,
                            validator: (phoneNumber) => authProvider.validatePhoneNumber(phoneNumber!.trim()),
                            label: "Phone Number"
                          ),
                                  
                          const SizedBox(height: 10),
                      
                          CustomTextFormField(
                            keyboardInput: TextInputType.streetAddress,
                            controller: placeOfResidenceController,
                            validator: (place) => authProvider.validatePlaceOfResidence(place!.trim()),
                            label: "Place of Residence"
                          ),
                      
                          const SizedBox(height: 20,),
                      
                          profileProvider.userStatus == DataStatus.failed ?
                            Text(
                              profileProvider.userError.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ) :
                            Container(),   
                        ],
                      ),
                    ),
                  ),
                ),
        
                Visibility(
                  visible: !_hideSaveButton,
                  child: AnimatedBuilder(
                    animation: scrollController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: scrollController.position.userScrollDirection == ScrollDirection.reverse ? 0 : 75,
                          child: Wrap(
                            children: [
                              child!
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      child: PrimaryButton(
                        label: "Save", 
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (selectedFile != null) {
                              await profileProvider.setProfileImage(selectedFile!);
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            bool successfulUpload = await profileProvider.setUserProfile(
                              fullName: fullNameController.text.trim(),
                              dateOfBirth: dateOfBirth,
                              phoneNumber: phoneController.text.trim(),
                              email: emailController.text.trim(),
                              placeOfResidence: placeOfResidenceController.text.trim(),
                            );
                            if (successfulUpload && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        profileProvider.userStatus == DataStatus.processing || profileProvider.imageStatus == DataStatus.processing ?
                  const CustomLoadingOverlay(enableDarkBackground: true,) :
                  Container()
      ],
    );
  }
}