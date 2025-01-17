import 'package:angertable/controllers/task_controller.dart';
import 'package:angertable/models/task.dart';
import 'package:angertable/ui/theme.dart';
import 'package:angertable/ui/widgets/button.dart';
import 'package:angertable/ui/widgets/input_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
   DateTime _selectedDate = DateTime.now();
   String _endTime="09:30 PM";
   String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  
  int _selectedColor=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.dialogBackgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right:20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Episode",
                style: headingStyle,

              ),
               MyInputField(title: "Title", hint: "Enter your title", controller: _titleController, widget: const Text("widget")),
               MyInputField(title: "Note", hint: "Enter your note", controller: _noteController, widget: const Text("widget")),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate), 
              widget: IconButton(
                icon:const Icon(Icons.calendar_today_outlined,
                color:Colors.grey
                
                ),
                onPressed: (){
                  if (kDebugMode) {
                    print("Hi there");
                  }
                  _getDatefromUser();


                },
                ),
                ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time", 
                      hint: _startTime, 
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime:true);

                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color:Colors.grey,
                        ),
                      ),
                      ),
                      ),
                      const SizedBox(width: 12,),

                      Expanded(
                    child: MyInputField(
                      title: "End Time", 
                      hint: _endTime, 
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime:false);

                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color:Colors.grey,
                        ),
                      ),
                      ),
                      ),


                ],
              ),

              const SizedBox(height: 18,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  _colorPallete(),
                  MyButton(label: "Create log", onTap: ()=>_validateData())
                ],
              )



            ],
          ),
        ),
          
        )
      );
  }


  _validateData(){
    if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();

    }else if(_titleController.text.isEmpty ||_noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: pinkClr,
      icon: const Icon(Icons.warning_amber_rounded,
      color:Colors.red
      )
      );



    }



  }

  _addTaskToDb() async{
    int value = await _taskController.addTask(
      task:Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      isCompleted: 0, 
    )

    );
    if (kDebugMode) {
      print("My id is "+"$value");
    }


  }

  _colorPallete(){
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color",
                      style: titleStyle,
                      
                      ),
                      const SizedBox(height: 8.0,),
                    Wrap(
                      children: List<Widget>.generate(
                        3, 
                      (int index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedColor=index;
                            });


                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                              child: _selectedColor==index?const Icon(Icons.done,
                              color: Colors.white,
                                size: 16,
                                
                                ):Container(),
                          
                            ),
                          ),
                        );
                      }
                      ),
                    )  
                    ],
                  );
  }

  _appBar(BuildContext context){
  return AppBar(
    elevation: 0,
    leading: GestureDetector(
      onTap:(){
        Get.back();


      },
      child: const Icon(Icons.arrow_back_ios,
      size: 20,),
    ),
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage("images/profile.png"),
      ),
      SizedBox(width: 20,),
    ],
  );
}

_getDatefromUser() async {
  DateTime?pickerDate=await showDatePicker(
    context: context, 
    initialDate: DateTime.now(),
    firstDate: DateTime(2015), 
    lastDate: DateTime(2123)
    
    );

    if(pickerDate!=null){
      _selectedDate = pickerDate;
    }else{
      if (kDebugMode) {
        print("it's null or something is wrong");
      }
    }

}

_getTimeFromUser({required bool isStartTime}) async {
  var pickedTime = await _showTimePicker();
  String formatedTime=pickedTime.format(context);
  if(pickedTime==null){
    if (kDebugMode) {
      print("Time canceled");
    }
  }else if(isStartTime==true){
    setState(() {
      _startTime=formatedTime;
    });


  }else if(isStartTime==false){
    setState(() {
      _endTime=formatedTime;
    });


  }
  
}

_showTimePicker(){
  return showTimePicker(
    initialEntryMode: TimePickerEntryMode.input,
    context: context, 
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]), 
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
      );
}
}