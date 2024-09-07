

import 'package:angertable/services/theme_services.dart';
import 'package:angertable/ui/theme.dart';
import 'package:angertable/ui/widgets/add_task_bar.dart';
import 'package:angertable/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:  Column(children: [
        _addTaskBar(),
        _addDateBar(),
        const SizedBox(height: 10,),
        _showTasks(),
        
          ],
        ),
        
      );
    
  }
}


_showTasks(){
  return Expanded(
    child: Obx((){
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index){
        
            return AnimationConfiguration.staggeredList(
              position: index, 
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if (kDebugMode) {
                            print("Tapped");
                          }


                        },
                        child: TaskTile(_taskController.taskList[index]),
                      )

                    ],
                  ),),));
          
        });


}),
);
}

_addDateBar(){
  return Container(
          margin: const EdgeInsets.only(top:20, left:20),
          child: DatePicker(
            DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: DateTime.now(),
            selectionColor: primaryClr,
            selectedTextColor: Colors.white,
            dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color:Colors.grey
            )
            ),
            dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:Colors.grey
            )
            ),
            monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:Colors.grey
            )
            ),
            onDateChange: (date){
            
              
              
            },
          ),
        );

}

_addTaskBar(){
  return Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                  ),
                  Text("Today",
                  style: headingStyle,
                  )
              ],
              ),
              MyButton(label: "+ Add Episode", onTap: () async {
                
                await Get.to(()=> const AddTaskPage());
                _taskController.getTasks();
              
              
              
              }
              
              
              
              )
            ]
          )
        );
}

_appBar(){
  return AppBar(
    elevation: 0,
    leading: GestureDetector(
      onTap:(){
        ThemeService().switchTheme();

      },
      child: Icon(Get.isDarkMode ?Icons.wb_sunny_outlined:Icons.nightlight_round,
      size: 20,
      color: Get.isDarkMode ? Colors.white:Colors.black
      ),
    ),
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage("images/profile.png"),
      ),
      SizedBox(width: 20,),
    ],
  );
}