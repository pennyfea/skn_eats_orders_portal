import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skneats_order_portal/data/utils/order_route_helper.dart';
import '../../../data/blocs.dart';
import '../../../data/models.dart';
import '../components.dart';

class ReadyOrderTile extends StatefulWidget {
  final CustomerOrder order;
  
  const ReadyOrderTile({super.key, required this.order});

  @override
  State<ReadyOrderTile> createState() => _ReadyOrderTileState();
}

class _ReadyOrderTileState extends State<ReadyOrderTile> {
  String _formattedDuration = '';
  String _arrivalTime = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _updateRouteInfo();
  }

  Future<void> _updateRouteInfo() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.order.driverLocation == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Waiting for driver';
        });
        return;
      }

      if (widget.order.storeLocation == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Store location not available';
        });
        return;
      }

      final routeData = await widget.order.computeRoute(
        widget.order.driverLocation!.latitude,
        widget.order.driverLocation!.longitude,
      );

      if (!mounted) return;

      if (routeData != null) {
        final durationInSeconds = routeData['total_duration'] as int;
        final arrivalTime = DateTime.now().add(Duration(seconds: durationInSeconds));
        
        setState(() {
          _formattedDuration = _formatDuration(durationInSeconds);
          _arrivalTime = _formatTime(arrivalTime);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not calculate route';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error calculating route';
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) {
      return '$minutes mins';
    }
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildArrivalInfo() {
    if (_isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_formattedDuration.isNotEmpty) ...[
          Text(
            _formattedDuration,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
        ],
        if (_arrivalTime.isNotEmpty)
          Text(
            'ETA $_arrivalTime',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerOrderBloc, CustomerOrderState>(
      listenWhen: (previous, current) {
        if (current is CustomerOrderLoaded) {
          final updatedOrder = current.orders.firstWhere(
            (o) => o.id == widget.order.id,
            orElse: () => widget.order,
          );
          return updatedOrder.driverLocation != widget.order.driverLocation;
        }
        return false;
      },
      listener: (context, state) {
        _updateRouteInfo();
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.order.firstName} ${widget.order.lastName[0]}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.order.id.substring(0, 5)} • ${widget.order.cartItems.length} item${widget.order.cartItems.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Driver to Store',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  _buildArrivalInfo(),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  } 


  // void _showCustomerOrderDialog(BuildContext context, CustomerOrder order) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CustomerOrderDialog(customerOrder: order);
  //     },
  //   );
  // } 
 }

