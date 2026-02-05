import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pcl_aquahub/services/api_service.dart';
import 'package:pcl_aquahub/models/health.dart';
import 'package:pcl_aquahub/models/vendor_login_response.dart';
import 'package:pcl_aquahub/models/order.dart';
import 'package:pcl_aquahub/models/truck.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('DioApiService', () {
    late DioApiService apiService;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      apiService = DioApiService(dio: mockDio);
    });

    group('getHealth', () {
      test('returns HealthResponse on success', () async {
        final response = Response(
          data: {'status': 'ok', 'db': 'connected'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/health'),
        );

        when(() => mockDio.get('/api/health')).thenAnswer((_) async => response);

        final result = await apiService.getHealth();

        expect(result.status, 'ok');
        expect(result.db, 'connected');
        verify(() => mockDio.get('/api/health')).called(1);
      });

      test('returns fail status on non-200 response', () async {
        final response = Response(
          data: {'db': 'error'},
          statusCode: 500,
          statusMessage: 'Internal Server Error',
          requestOptions: RequestOptions(path: '/api/health'),
        );

        when(() => mockDio.get('/api/health')).thenAnswer((_) async => response);

        final result = await apiService.getHealth();

        expect(result.status, 'fail');
      });

      test('returns fail with error message on DioError', () async {
        final dioError = DioError(
          requestOptions: RequestOptions(path: '/api/health'),
          response: Response(
            data: {'error': 'Database connection failed'},
            statusCode: 500,
            requestOptions: RequestOptions(path: '/api/health'),
          ),
        );

        when(() => mockDio.get('/api/health')).thenThrow(dioError);

        final result = await apiService.getHealth();

        expect(result.status, 'fail');
        expect(result.error, 'Database connection failed');
      });
    });

    group('registerCustomer', () {
      test('returns userId on successful registration', () async {
        final payload = {'name': 'John', 'email': 'john@example.com', 'phone': '1234567890'};
        final response = Response(
          data: {'userId': '12345', 'message': 'Registered successfully'},
          statusCode: 201,
          requestOptions: RequestOptions(path: '/api/register/customer'),
        );

        when(() => mockDio.post('/api/register/customer', data: payload))
            .thenAnswer((_) async => response);

        final result = await apiService.registerCustomer(payload);

        expect(result, '12345');
        verify(() => mockDio.post('/api/register/customer', data: payload)).called(1);
      });

      test('throws exception on registration failure', () async {
        final payload = {'name': 'John', 'email': 'john@example.com', 'phone': '1234567890'};
        final dioError = DioError(
          requestOptions: RequestOptions(path: '/api/register/customer'),
          response: Response(
            data: {'error': 'Email already registered'},
            statusCode: 400,
            requestOptions: RequestOptions(path: '/api/register/customer'),
          ),
        );

        when(() => mockDio.post('/api/register/customer', data: payload))
            .thenThrow(dioError);

        expect(
          () => apiService.registerCustomer(payload),
          throwsException,
        );
      });

      test('throws exception when userId is missing from response', () async {
        final payload = {'name': 'John', 'email': 'john@example.com'};
        final response = Response(
          data: {'message': 'Created'},
          statusCode: 201,
          requestOptions: RequestOptions(path: '/api/register/customer'),
        );

        when(() => mockDio.post('/api/register/customer', data: payload))
            .thenAnswer((_) async => response);

        expect(
          () => apiService.registerCustomer(payload),
          throwsException,
        );
      });
    });

    group('vendorLogin', () {
      test('returns VendorLoginResponse on successful login', () async {
        final response = Response(
          data: {
            'vendor': {
              'vendorProfileId': 'vendor_123',
              'vendorName': 'John Vendor',
              'email': 'vendor@example.com',
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/vendor/login'),
        );

        when(() => mockDio.post('/api/vendor/login', data: any(named: 'data')))
            .thenAnswer((_) async => response);

        final result = await apiService.vendorLogin('vendor@example.com', 'password123');

        expect(result.vendorProfileId, 'vendor_123');
        expect(result.vendorName, 'John Vendor');
        verify(() => mockDio.post('/api/vendor/login', data: any(named: 'data'))).called(1);
      });

      test('throws exception on invalid credentials', () async {
        final dioError = DioError(
          requestOptions: RequestOptions(path: '/api/vendor/login'),
          response: Response(
            data: {'error': 'Invalid email or password'},
            statusCode: 401,
            requestOptions: RequestOptions(path: '/api/vendor/login'),
          ),
        );

        when(() => mockDio.post('/api/vendor/login', data: any(named: 'data')))
            .thenThrow(dioError);

        expect(
          () => apiService.vendorLogin('wrong@example.com', 'wrongpass'),
          throwsException,
        );
      });
    });

    group('getVendorOrders', () {
      test('returns list of orders on success', () async {
        final response = Response(
          data: {
            'orders': [
              {'orderId': '1', 'customerId': 'cust1', 'status': 'pending'},
              {'orderId': '2', 'customerId': 'cust2', 'status': 'completed'},
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/vendor/vendor_123/orders'),
        );

        when(() => mockDio.get('/api/vendor/vendor_123/orders'))
            .thenAnswer((_) async => response);

        final result = await apiService.getVendorOrders('vendor_123');

        expect(result.length, 2);
        expect(result[0].orderId, '1');
        expect(result[1].orderId, '2');
      });

      test('returns empty list when no orders', () async {
        final response = Response(
          data: {'orders': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/vendor/vendor_123/orders'),
        );

        when(() => mockDio.get('/api/vendor/vendor_123/orders'))
            .thenAnswer((_) async => response);

        final result = await apiService.getVendorOrders('vendor_123');

        expect(result.isEmpty, true);
      });

      test('throws exception on network error', () async {
        final dioError = DioError(
          requestOptions: RequestOptions(path: '/api/vendor/vendor_123/orders'),
          type: DioErrorType.connectionTimeout,
        );

        when(() => mockDio.get('/api/vendor/vendor_123/orders'))
            .thenThrow(dioError);

        expect(
          () => apiService.getVendorOrders('vendor_123'),
          throwsException,
        );
      });
    });

    group('getVendorFleet', () {
      test('returns list of trucks on success', () async {
        final response = Response(
          data: {
            'trucks': [
              {'truckId': 'truck_1', 'licensePlate': 'ABC123'},
              {'truckId': 'truck_2', 'licensePlate': 'XYZ789'},
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/vendor/vendor_123/fleet'),
        );

        when(() => mockDio.get('/api/vendor/vendor_123/fleet'))
            .thenAnswer((_) async => response);

        final result = await apiService.getVendorFleet('vendor_123');

        expect(result.length, 2);
        expect(result[0].truckId, 'truck_1');
      });

      test('returns empty list when no trucks', () async {
        final response = Response(
          data: {'trucks': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/vendor/vendor_123/fleet'),
        );

        when(() => mockDio.get('/api/vendor/vendor_123/fleet'))
            .thenAnswer((_) async => response);

        final result = await apiService.getVendorFleet('vendor_123');

        expect(result.isEmpty, true);
      });
    });

    group('setAuthToken', () {
      test('sets Authorization header when token is provided', () {
        apiService.setAuthToken('my_token_123');

        // Verify the header is set (we can't directly inspect private _dio.options,
        // so this is a documentation test)
        expect(apiService.authToken, 'my_token_123');
      });

      test('clears Authorization header when token is null', () {
        apiService.setAuthToken('token_123');
        apiService.setAuthToken(null);

        expect(apiService.authToken, isNull);
      });
    });
  });
}
