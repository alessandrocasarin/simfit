import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Training Metrics Explained',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
              buildSectionTitle(context, 'TRIMP (Training Impulse)'),
              buildParagraph(
                'TRIMP is a measure of training load based on exercise duration and intensity. It is calculated as:'
              ),
              Math.tex(
                  r'TRIMP = \text{duration (minutes)} \times \%HRR \times \text{weighting factor}',
                  textStyle: TextStyle(fontSize: 12),
                ),
              
              SizedBox(height: 10),
               Math.tex(
                  r'\%HRR = \frac{\text{avg HR during session} - \text{HR rest}}{\text{HR max} - \text{HR rest}}',
                  textStyle: TextStyle(fontSize: 12),
                ),
              
              SizedBox(height: 10),
              buildParagraph(
                'The weighting factor is gender-specific: 1.67 for women and 1.92 for men. Higher TRIMP values indicate more intense training sessions.',
              ),
              buildSectionTitle(context, 'ACL (Acute Training Load)'),
              buildParagraph(
                'ACL represents the short-term training load, specifically over the past 7 days. It helps in understanding the recent training intensity. Higher ACL values indicate higher recent training stress.',
              ),
              buildSectionTitle(context, 'CTL (Chronic Training Load)'),
              buildParagraph(
                'CTL represents the long-term training load, specifically from the beginning of the mesocycle. It provides a measure of an athlete\'s fitness. Higher CTL values indicate higher overall fitness.',
              ),
              buildSectionTitle(context, 'TSB (Training Stress Balance)'),
              buildParagraph(
                'TSB is calculated as CTL - ACL. It indicates the balance between fitness and fatigue. Positive TSB values suggest that the athlete is well-rested and ready to perform, while negative values indicate fatigue.',
              ),
              buildSectionTitle(context, 'Interpreting the Values'),
              buildParagraph(
                'TRIMP:\n'
                '- Easy session: <50\n'
                '- Moderate session: 50-120\n'
                '- Hard session: 120-250\n'
                '- Very hard session: >250\n\n'
                'TSB:\n'
                '- Very low performances: TSB < -25  🥵\n'
                '- Low performances: -25 ≤ TSB < -10  😟\n'
                '- Neutral performances: -10 ≤ TSB ≤ 5  😐\n'
                '- Good performances: 5 < TSB ≤ 20  😊\n'
                '- Very good performances: TSB > 20  🤩',
              ),
              buildSectionTitle(context, 'Interpreting the Plot'),
              buildParagraph(
                'A plot of ACL, CTL, and TSB over a mesocycle provides insights into training load and recovery:\n'
                '- ACL and CTL rising together indicates balanced training.\n'
                '- If ACL rises sharply while CTL remains stable, it indicates an increase in recent training load, which may lead to fatigue.\n'
                '- TSB trending positive indicates good recovery and readiness to perform, while negative TSB indicates accumulating fatigue.',
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
