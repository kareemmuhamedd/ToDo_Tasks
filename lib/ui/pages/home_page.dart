import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/ui/pages/notification_screen.dart';
import 'package:todo/ui/size_config.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/theme_services.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    // notifyHelper.requestAndroidPermission();
    notifyHelper.initializeNotification();
    _taskController.getTask();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 6),
            _showTask(),
          ],
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
          print('the length is*********** ${TaskController().taskList.length}');
          // NotifyHelper().displayNotification(
          //   title: 'Theme Changed',
          //   body: 'Tessssssst',
          // );
          // NotifyHelper().scheduledNotification();

          // for(var i in _taskController.taskList){
          //   print('///////////// ${i.date}////////////\n');
          // }
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 11),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/person.jpeg'),
          ),
        )
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today ',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTask();
            },
            label: 'Add Task',
            color: Theme.of(context).primaryColor,
          ),
          MyButton(
            onTap: () {
              Get.defaultDialog(
                  title: 'Attention',
                  middleText: "Hello world!",
                  backgroundColor: Colors.white,
                  titleStyle: const TextStyle(color: Colors.black),
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  cancelTextColor: Colors.black,
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.black,
                  barrierDismissible: true,
                  radius: 12,
                  onConfirm: () {
                    notifyHelper.cancelAllNotification();
                    _taskController.deleteAllTask();
                    Get.back();
                    Get.snackbar(
                      'All was deleted',
                      'Done Successfully, Press Add Task button if you need to add new one',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                      duration: const Duration(seconds: 4),
                    );
                  },
                  content: const Text(
                    '''Are you sure ? All tasks will be removed.''',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ));
            },
            label: 'Delete All',
            color: Colors.red[500]!,
          )
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  /// function for refresh indicator
  Future<void> _onRefresh() async {
    // DateTime now=DateTime.now();
    // for(var i in _taskController.taskList){
    //   DateTime date = DateFormat('M/d/yyyy').parse(i.date!);
    //   if(date.isBefore(now)){
    //     print('***********i am sorry***********');
    //   }
    //   else{
    //     print('***********you have still time***********');
    //   }
    // }

    _taskController.getTask();
    _showTask();
  }

  _showTask() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: _taskController.taskList.length,
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];
                //var hour = task.startTime.toString().split(':')[0];
                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                      DateFormat.yMd().parse(task.date!),
                                    )
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selectedDate.day)) {
                  // var minutes = task.startTime.toString().split(':')[1];
                  // debugPrint('My time is $hour');
                  // debugPrint('My minutes is $minutes');

                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);

                  NotifyHelper().scheduledNotification(
                    int.parse(myTime.toString().split(':')[0]),
                    int.parse(myTime.toString().split(':')[1]),
                    task,
                  );
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                } else if (task.repeat == 'None') {
                  Future.delayed(const Duration(days: 1), () {
                    _taskController.deleteTask(task);
                    NotifyHelper().cancelNotification(task);
                  });
                  return Container();
                }
                return Container();
              },
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'assets/images/task.svg',
                    height: 90,
                    semanticsLabel: 'Task',
                    //color: primaryClr.withOpacity(0.6), /////is deprecated
                    colorFilter: ColorFilter.mode(
                        primaryClr.withOpacity(0.6), BlendMode.srcIn),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You don\'t have any tasks yet!\nAdd new tasks to make your days productive.',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        _taskController.markTaskAsCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTask(task);
                  print('deleted item is ${task.id}');
                  Get.back();
                },
                clr: Colors.red[500]!,
              ),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
              _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
