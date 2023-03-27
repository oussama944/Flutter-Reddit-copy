import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_app/features/models/user_model.dart';
import '../../../core/constants/firebase_constraints.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_provider.dart';
import '../../../core/type_defs.dart';


final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});



class UserProfileRepository{
  final FirebaseFirestore _firestore;
    UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

      CollectionReference get _users => _firestore.collection(FirebaseConstants.communitiesCollection);


    FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}