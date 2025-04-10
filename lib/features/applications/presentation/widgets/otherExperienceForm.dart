import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us/general_widgets/customTextFormField.dart';

class OtherExperienceForm extends StatelessWidget {
  OtherExperienceForm({
    super.key,
    required this.positionHeldController,
    this.positionHeldValidator,
    required this.eventController,
    this.eventValidator,
    required this.locationController,
    this.locationValidator,
    required this.startDateController,
    this.startDateValidator,
    required this.endDateController,
    this.endDateValidator,
    this.startDate,
    this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
    this.readOnly = false,
  });

  final TextEditingController positionHeldController;
  final TextEditingController eventController;
  final TextEditingController locationController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;

  final String? Function(String?)? positionHeldValidator;
  final String? Function(String?)? eventValidator;
  final String? Function(String?)? locationValidator;
  final String? Function(String?)? startDateValidator;
  final String? Function(String?)? endDateValidator;

  final DateTime? startDate;
  final DateTime? endDate;

  final Function() onStartDateTap;
  final Function() onEndDateTap;

  final bool readOnly;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          readOnly: readOnly,
          label: "Position",
          controller: positionHeldController,
          validator: positionHeldValidator != null ? (input) => positionHeldValidator!(input) : null,
        ),

        const SizedBox(height: 10,),

        CustomTextFormField(
          readOnly: readOnly,
          label: "Event",
          controller: eventController,
          validator: eventValidator != null ? (input) => eventValidator!(input) : null,
        ),

        const SizedBox(height: 10,),

        CustomTextFormField(
          readOnly: readOnly,
          label: "Location",
          keyboardInput: TextInputType.multiline,
          maxLines: null,
          controller: locationController,
          validator: locationValidator != null ? (input) => locationValidator!(input) : null,
        ),

        const SizedBox(height: 10,),

        Row(
          children: [
            Expanded(
              child: CustomFieldButton(
                label: "Start Date",
                controller: startDateController,
                validator: startDateValidator != null ? (input) => startDateValidator!(input) : null,
                defaultInnerLabel: (startDateController.text.isNotEmpty) ? formatter.format(startDate!) : "Select Date",
                suffixIcon: const Icon(
                  Icons.calendar_month_rounded
                ),
                onFieldTap: readOnly ? null : onStartDateTap,
              ),
            ),

            const SizedBox(width: 10,),
            
            Expanded(
              child: CustomFieldButton(
                label: "End Date",
                  controller: endDateController,
                  validator:endDateValidator != null ? (input) => endDateValidator!(input) : null,
                  defaultInnerLabel: (endDateController.text.isNotEmpty) ? formatter.format(endDate!) : "Select Date",
                  suffixIcon: const Icon(
                    Icons.calendar_month_rounded
                  ),
                  onFieldTap: readOnly ? null : onEndDateTap,
                ),
            ),
          ],
        ),
      ],
    );
  }
}