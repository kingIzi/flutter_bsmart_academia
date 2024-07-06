import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';
import 'package:namer_app/core/entities/Facility.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';
import 'package:namer_app/customs/custom_text_fields.dart';
import 'package:namer_app/services/api/auth_requests.dart';

class FacilityController extends TextEditingController {
  int? facilityId;
  FacilityController({super.text, this.facilityId});
}

class StudentDetail {
  final FacilityController facilityRegSno;
  final TextEditingController admissionNo;

  const StudentDetail(
      {required this.facilityRegSno, required this.admissionNo});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Facility_Reg_Sno': facilityRegSno.facilityId,
      'Admission_No': admissionNo.text
    };
  }
}

List<Facility> _parseFacilitiesSuggestions(
    Iterable response, String searchKey) {
  assert(response.isNotEmpty);
  final facilities = response.map((e) => Facility.fromJson(e)).toList();
  final sortedOptions = facilities
      .where(
          (facility) => facility.facilityName.toLowerCase().contains(searchKey))
      .toList();
  return sortedOptions;
}

List<Facility> _determineFacilitiesSuggestionsState(
    Iterable response, String searchKey) {
  final hasErrorResponse = LocalResponseModel.hasErrorResponse(response);
  if (hasErrorResponse) {
    return [];
  } else {
    return _parseFacilitiesSuggestions(response, searchKey);
  }
}

Future<List<Facility>> getSuggestions(String key) async {
  try {
    final response =
        await StudentDetailsApi.getFacilities.sendRequest(body: {});
    if (response['response'] == null) throw response['message'];
    return _determineFacilitiesSuggestionsState(
        response['response'], key.toLowerCase());
  } catch (e) {
    //showErrorQuickAlert(_buildContext, 'Failed', e.toString());
    return [];
  }
}

Form getStudentDetailsForm(
    GlobalKey<FormState> formKey, StudentDetail studentDetail) {
  return Form(
    key: formKey,
    onChanged: () {
      Form.of(primaryFocus!.context!).save();
    },
    child: Column(
      children: [
        Column(
          children: [
            const Row(
              children: [
                Text(
                  'Facility',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 1,
            ),
            AsyncAutocomplete<Facility>(
              controller: studentDetail.facilityRegSno,
              validator: cannotBeBlankValidator,
              inputFormatter: [LengthLimitingTextInputFormatter(255)],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search facility...',
                prefixIcon: const Icon(
                  Icons.history_edu,
                  color: Colors.teal,
                ),
              ),
              asyncSuggestions: getSuggestions,
              suggestionBuilder: (Facility facility) => ListTile(
                title: Text(facility.facilityName),
              ),
              onTapItem: (Facility facility) {
                studentDetail.facilityRegSno.text = facility.facilityName;
                studentDetail.facilityRegSno.facilityId =
                    facility.facilityRegSno;
              },
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        CustomTextFormField(
            validator: cannotBeBlankValidator,
            labelText: 'Admission Number',
            hintText: 'Admission Number',
            controller: studentDetail.admissionNo,
            prefixIcon: Icons.school,
            textCapitalization: TextCapitalization.none,
            inputFormatters: [
              LengthLimitingTextInputFormatter(255),
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
              FilteringTextInputFormatter.deny(
                RegExp(r'[^0-9]'),
              )
            ]),
      ],
    ),
  );
}
