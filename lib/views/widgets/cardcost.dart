part of 'widgets.dart';

class CardCost extends StatefulWidget {
  final Costs costs;
  const CardCost(this.costs);

  @override
  State<CardCost> createState() => _CardCostState();
}

class _CardCostState extends State<CardCost> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.costs;
    return Card(
        color: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
        child: Container(
          child: Column(
            children: [
              // Create a Row to display Image and ListTile in two columns
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align the columns at the top
                children: [
                  // First column: Image
                  Flexible(
                     flex: 1, // Adjust flex as needed
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      height: 50.0, // Set the desired height
                      child: Image.asset('lib/views/widgets/star.png',
                          fit: BoxFit.fill),
                    ),
                  ),

                  // Second column: ListTile
                  Flexible(
                    flex: 3, // Adjust flex as needed
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      title: Text("${c.description} (${c.service})"),
                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text at the left
                        children: [
                          if (c.cost != null &&
                              c.cost!
                                  .isNotEmpty) // Check if c.cost is not null and not empty
                            Text("Biaya: Rp${c.cost![0].value}"),
                          if (c.cost != null &&
                              c.cost!
                                  .isNotEmpty) // Check if c.cost is not null and not empty
                            Text(
                              "Estimasi sampai: ${c.cost![0].etd}",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
