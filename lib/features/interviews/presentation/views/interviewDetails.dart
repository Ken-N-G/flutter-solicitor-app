import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/interviews/domain/interviewProvider.dart';
import 'package:jobs_r_us/features/job_postings/domain/jobProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/features/view_employers/presentation/widgets/employerProfilePicture.dart';
import 'package:jobs_r_us/general_widgets/headerAndBodySection.dart';
import 'package:jobs_r_us/general_widgets/primaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class InterviewDetails extends StatefulWidget {
  const InterviewDetails({super.key});

  @override
  State<InterviewDetails> createState() => _InterviewDetailsState();
}

class _InterviewDetailsState extends State<InterviewDetails> {

  final DateFormat formatter = DateFormat("d MMM yyyy").add_jm();

  Color setPrimaryColor(String status) {
    if (status == InterviewStatus.pendingSchedule.status) {
      return InterviewStatus.pendingSchedule.color;
    } else if (status == InterviewStatus.awaitingInterview.status) {
      return InterviewStatus.awaitingInterview.color;
    } else if (status == InterviewStatus.happeningNow.status) {
      return InterviewStatus.happeningNow.color;
    } else if (status == InterviewStatus.completed.status) {
      return InterviewStatus.completed.color; 
    }  else {
      return InterviewStatus.archived.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final employerProvider = Provider.of<EmployerProvider>(context);
    final interviewProvider = Provider.of<InterviewProvider>(context);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Interview Details",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EmployerProfilePicture(
                      profileUrl: employerProvider.selectedEmployer.profileUrl,
                      onProfileTap: () {
                        Navigator.pushNamed(context, ScreenRoutes.employerDetails.route);
                      },
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            "Interview for ",
                            style: Theme.of(context).textTheme.bodyLarge
                          ),

                          Text(
                            "${jobProvider.selectedJob.title} ",
                            style: Theme.of(context).textTheme.bodyLarge
                          ),

                          Text(
                            "with ",
                            style: Theme.of(context).textTheme.bodyLarge
                          ),

                          Text(
                            employerProvider.selectedEmployer.name,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w700
                            ),  
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: setPrimaryColor(interviewProvider.selectedInterview.status).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Text(
                      interviewProvider.selectedInterview.status,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: setPrimaryColor(interviewProvider.selectedInterview.status)
                      ),
                    ),
                  ),
                ), 

                const SizedBox(height: 30,),

                interviewProvider.selectedInterview.status == InterviewStatus.pendingSchedule.status ?
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
          
                      const SizedBox(width: 5,),
                      
                      PrimaryButton(
                        label: "Choose Interview Time", 
                        width: null,
                        overrideTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, ScreenRoutes.pickTimeSlot.route);
                        },
                      ),
                    ],
                  ) : Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),

                      const SizedBox(width: 5,),

                      Text(
                          formatter.format(interviewProvider.selectedInterview.selectedDate),
                          style: Theme.of(context).textTheme.bodyLarge
                        ),
                    ],
                  ),  

                const SizedBox(height: 10,),

                Row(
                  children: [
                    Icon(
                      Icons.contacts_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
        
                    const SizedBox(width: 5,),
                    
                    Text(
                      interviewProvider.selectedInterview.interviewMethod,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ],
                ),  

                const SizedBox(height: 10,),

                Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
        
                    const SizedBox(width: 5,),
                    
                    Text(
                      interviewProvider.selectedInterview.link.isNotEmpty ? interviewProvider.selectedInterview.link : "No link is given",
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                  ],
                ),  
                
                const SizedBox(height: 30,),

                HeaderAndBodySection(
                  sectionHeader: "Additional Preparations", 
                  body: interviewProvider.selectedInterview.additionalPreparations
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}