import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {
  // register user
  Future<dynamic> register(
      String username, String email, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // send verify email
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      return user;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code.replaceAll("-", " "));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // log in user
  Future<dynamic> login(String email, String password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // send verify email if not verified
      var isEmailVerified =
          await FirebaseAuth.instance.currentUser?.emailVerified ?? true;
      if (!isEmailVerified) {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code.replaceAll("-", " "));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //forgot password
  Future<dynamic> passwordReset(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // get current user id
  getCurrentUserid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
  }

  // log out user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //delete account
  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      // requires-recent-login
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code.replaceAll("-", " "));
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
