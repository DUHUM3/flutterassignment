import 'package:flutter/material.dart';
import '../api/controlcourse_service.dart';
import 'create_courses.dart';
import 'editcourse.dart';

class abdu_CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<abdu_CoursesScreen> {
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      final List<Map<String, dynamic>> fetchedCourses =
          await abdu_ControlcourseService.fetchCourses();
      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> deleteCourse(int courseId) async {
    try {
      await abdu_ControlcourseService.deleteCourse(courseId);
      setState(() {
        courses.removeWhere((course) => course['id'] == courseId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateCourse(
      int courseId, Map<String, dynamic> updatedData) async {
    try {
      await abdu_ControlcourseService.updateCourse(courseId, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course updated successfully.')),
      );
      fetchCourses(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => abdu_AddItemScreen()),
              ).then((_) => fetchCourses());
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchCourses,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : courses.isEmpty
              ? Center(child: Text('No courses available.'))
              : ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (course['photo'] != null)
                              Image.network(
                                course['photo'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(height: 10),
                            Text(
                              course['subject'] ?? 'No Subject',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            SizedBox(height: 5),
                            Text(
                              course['title'] ?? 'No Title',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5),
                            Text(
                              course['overview'] ?? 'No Overview',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            abdu_EditCourseScreen(course: course),
                                      ),
                                    ).then((updatedData) {
                                      if (updatedData != null) {
                                        updateCourse(course['id'], updatedData);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.edit, color: Colors.green),
                                  label: Text('Edit'),
                                ),
                                SizedBox(width: 10),
                                TextButton.icon(
                                  onPressed: () {
                                    deleteCourse(course['id']);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  label: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
