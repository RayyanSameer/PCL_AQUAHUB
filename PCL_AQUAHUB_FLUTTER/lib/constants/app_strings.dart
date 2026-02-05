/// Internationalization (i18n) strings for the AquaHub app.
/// Use this to manage all user-facing strings in a single location.
/// In future, integrate with intl package for plurals and date formatting.
class AppStrings {
  // General
  static const String appName = 'PCL AquaHub';
  static const String appVersion = '0.1.0';

  // Navigation
  static const String back = 'Back';
  static const String next = 'Next';
  static const String cancel = 'Cancel';
  static const String submit = 'Submit';
  static const String save = 'Save';
  static const String delete = 'Delete';

  // Auth
  static const String login = 'Sign In';
  static const String logout = 'Sign Out';
  static const String register = 'Register';
  static const String email = 'Email Address';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot your password?';
  static const String enterValidEmail = 'Please enter a valid email address';
  static const String passwordMinLength = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String required = 'This field is required';
  static const String loginSuccess = 'Successfully logged in';
  static const String loginFailed = 'Login failed. Please check your credentials.';
  static const String logoutSuccess = 'Successfully logged out';
  static const String sessionExpired = 'Your session has expired. Please log in again.';

  // Customer Registration
  static const String registerCustomer = 'Register as Customer';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phone = 'Phone Number';
  static const String address = 'Street Address';
  static const String city = 'City';
  static const String state = 'State / Province';
  static const String postalCode = 'Postal Code';
  static const String registrationSuccess = 'Registration successful!';
  static const String registrationFailed = 'Registration failed. Please try again.';

  // Vendor
  static const String vendorLogin = 'Vendor Login';
  static const String vendorDashboard = 'Vendor Dashboard';
  static const String vendorOrders = 'Orders';
  static const String vendorFleet = 'Fleet';
  static const String orders = 'Orders';
  static const String trucks = 'Trucks';
  static const String noOrdersAvailable = 'No orders available at this time.';
  static const String noTrucksAvailable = 'No trucks available in your fleet.';

  // Health Check
  static const String health = 'Health';
  static const String healthCheck = 'System Health';
  static const String healthy = 'System is healthy';
  static const String unhealthy = 'System is not responding';
  static const String checkingHealth = 'Checking system status...';

  // Errors
  static const String errorOccurred = 'An error occurred';
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String contactSupport = 'Contact support';

  // Loading & Status
  static const String loading = 'Loading...';
  static const String saving = 'Saving...';
  static const String processingRequest = 'Processing your request...';
  static const String success = 'Success!';
  static const String failure = 'Failed';
  static const String tryAgain = 'Try Again';
  static const String dismiss = 'Dismiss';

  // Accessibility
  static const String closeButton = 'Close';
  static const String menuButton = 'Menu';
  static const String searchButton = 'Search';
  static const String filterButton = 'Filter';
  static const String moreOptions = 'More options';
  static const String expandDetails = 'Expand details';
  static const String collapseDetails = 'Collapse details';
}
