import 'package:civicsphere/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyJobDescriptionWorker extends StatefulWidget {
  const MyJobDescriptionWorker({super.key});

  @override
  State<MyJobDescriptionWorker> createState() => _MyJobDescriptionWorkerState();
}

class _MyJobDescriptionWorkerState extends State<MyJobDescriptionWorker> {
  String currentWorkerName = '';
  String acceptedWorkerName = '';
  bool isLoading = true;
  final List<Map<String, dynamic>> providers = [
    {
      'name': 'John Doe',
      'role': 'Plumber',
      'rating': 4,
      'image': 'assets/image 5.png',
    },
    {
      'name': 'Jane Smith',
      'role': 'Electrician',
      'rating': 5,
      'image': 'assets/image 5.png',
    },
    {
      'name': 'Mike Johnson',
      'role': 'Carpenter',
      'rating': 3,
      'image': 'assets/image 5.png',
    },
  ];
@override
  void initState() {
    super.initState();
    loadWorkerData();
  }
  Future<void> loadWorkerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? workerName = prefs.getString('name');  // worker's name
    String? acceptedName = prefs.getString('accepted_worker');  // accepted worker name

    setState(() {
      currentWorkerName = workerName ?? '';  
      acceptedWorkerName = acceptedName ?? '';  // offer
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B375D), Color(0xFF4D194D), Color(0xFF220440)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'C I V I C S P H E R E',
              style: TextStyle(
                color: AppColors.navbarcolorbg,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Logo
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 15, 5),
              child: SizedBox(
                height: screenHeight * 0.05,
                child: Image.asset('assets/teamwork-1.png', scale: 0.8),
              ),
            ),
            const SizedBox(height: 5),

       
            const Center(
              child: Text(
                'My Jobs',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

          
            const Center(
              child: Text(
                'Fix my sink',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

           
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.location_on, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text(
                  'Lorem ipsum dolor sit amet.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

           
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.calendar_today, color: Colors.black54, size: 20),
                SizedBox(width: 8),
                Text(
                  '17:00 | 27 Feb 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            
            Expanded(
              child: ListView.builder(
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              provider['image'],
                              width: screenWidth * 0.25,
                              height: screenWidth * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              
                                  Text(
                                    provider['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    provider['role'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        index < provider['rating']
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    
                                      SizedBox(
                                        height: screenHeight * 0.035,
                                        width: screenWidth * 0.22,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Chat',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),

                                
                                      SizedBox(
                                        height: screenHeight * 0.035,
                                        width: screenWidth * 0.22,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.darkviolet,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Hire Now',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
