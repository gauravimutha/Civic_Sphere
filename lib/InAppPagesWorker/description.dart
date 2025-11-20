import 'package:civicsphere/InAppPagesWorker/offer.dart';
import 'package:civicsphere/constants/colors.dart';
import 'package:civicsphere/models/job_displaymodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DescriptionPage extends StatelessWidget {
  final Job job;

  const DescriptionPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    String formattedDate = job.createdAt != null
        ? DateFormat('d MMM y, hh:mm a').format(job.createdAt!.toLocal())
        : "Unknown";

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B375D), Color(0xFF4D194D), Color(0xFF220440)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.navbarcolorbg),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Job Description',
              style: TextStyle(
                color: AppColors.navbarcolorbg,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(children: [
                      Icon(Icons.person_outline, color: Colors.black54),
                      const SizedBox(width: 10),
                      Text(job.customerName ?? "Unknown",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.title, color: Colors.black54),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(job.title ?? "No Title",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(Icons.category_outlined, color: Colors.black54),
                      const SizedBox(width: 10),
                      Text(job.category ?? "Not specified",
                          style: TextStyle(fontSize: 16)),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Container(
                    width: 160,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("⏰ Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(job.timePreference ?? "Anytime", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Container(
                    width: 160,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("💰 Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text("₹${job.amount ?? '0.00'}", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Container(
                    width: 140,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📊 Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(job.status ?? "Unknown", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Container(
                    width: 180,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🗓️ Created", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(formattedDate, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Description",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Text(job.description ?? "No Description",
                  style: TextStyle(fontSize: 15)),
            ),
            if (job.locationString != null) ...[
              const SizedBox(height: 24),
              Text("📍 Location",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Text(job.locationString!,
                    style: TextStyle(fontSize: 15)),
              ),
            ],
            const SizedBox(height: 30),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OfferPage(jobId: job.jobId),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF7B375D),
                        Color(0xFF4D194D),
                        Color(0xFF220440)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Make an Offer",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
