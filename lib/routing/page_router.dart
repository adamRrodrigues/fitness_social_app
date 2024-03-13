import 'package:fitness_social_app/auth/auth_state.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/error_screen.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/screen/create_exercise.dart';
import 'package:fitness_social_app/screen/create_meal_post.dart';
import 'package:fitness_social_app/screen/create_post.dart';
import 'package:fitness_social_app/screen/create_workout_post.dart';
import 'package:fitness_social_app/screen/edit_exercise.dart';
import 'package:fitness_social_app/screen/edit_workout.dart';
import 'package:fitness_social_app/screen/fetching_workout_screen.dart';
import 'package:fitness_social_app/screen/run_routine.dart';
import 'package:fitness_social_app/screen/search_workouts.dart';
import 'package:fitness_social_app/screen/user_page.dart';
import 'package:fitness_social_app/screen/view_post.dart';
import 'package:fitness_social_app/screen/view_routine.dart';
import 'package:fitness_social_app/screen/view_workout.dart';
import 'package:fitness_social_app/services/camera_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
    errorBuilder: (context, state) {
      return ErrorScreen(errorMessage: state.error.toString());
    },
    routes: <GoRoute>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthState();
          },
          routes: <GoRoute>[
            GoRoute(
              path: 'userPage',
              name: RouteConstants.userPage,
              pageBuilder: (context, state) {
                UserModel user = state.extra as UserModel;

                return CupertinoPage(
                    child: UserPage(
                  user: user,
                ));
              },
            ),
            GoRoute(
              path: 'createPage',
              name: RouteConstants.createPost,
              pageBuilder: (context, state) {
                return const CupertinoPage(child: CreatePost());
              },
            ),
            GoRoute(
              path: 'createMealPafe',
              name: RouteConstants.createMeal,
              pageBuilder: (context, state) {
                return const CupertinoPage(child: CreateMealPost());
              },
            ),
            GoRoute(
              path: 'cameraService',
              name: RouteConstants.cameraService,
              pageBuilder: (context, state) {
                return const CupertinoPage(child: CameraService());
              },
            ),
            GoRoute(
              path: 'createWorkoutPage',
              name: RouteConstants.createWorkout,
              pageBuilder: (context, state) {
                return const CupertinoPage(child: CreateWorkoutPost());
              },
            ),
            GoRoute(
              path: 'editWorkoutPage',
              name: RouteConstants.editWorkout,
              pageBuilder: (context, state) {
                // WorkoutModel post = state.extra as WorkoutModel;
                final params = state.extra! as Map<String, dynamic>;

                return CupertinoPage(
                    child: EditWorkout(
                        workoutModel: params['workoutModel'],
                        day: params["day"]));
              },
            ),
            GoRoute(
              path: 'createExercisePage',
              name: RouteConstants.createExercise,
              pageBuilder: (context, state) {
                List<ExerciseModel> exercises =
                    state.extra as List<ExerciseModel>;
                return CupertinoPage(
                    child: CreateExercise(
                  exercises: exercises,
                ));
              },
            ),
            GoRoute(
              path: 'editExercisePage',
              name: RouteConstants.editExercise,
              pageBuilder: (context, state) {
                // ExerciseModel exerciseModel = state.extra as ExerciseModel;
                final exerciseParams = state.extra! as Map<String, dynamic>;
                return CupertinoPage(
                    child: EditExercise(
                        editingExercise: exerciseParams["editingExercise"],
                        exercises: exerciseParams["exercises"],
                        index: exerciseParams['index']));
              },
            ),
            GoRoute(
              path: 'viewRotinePage/:id',
              name: RouteConstants.viewRoutinePage,
              pageBuilder: (context, state) {
                final uid = state.pathParameters['id'];
                int currentDay = state.extra as int;
                return CupertinoPage(
                    child: ViewRoutine(
                  uid: uid!,
                  currentDay: currentDay,
                ));
              },
            ),
            GoRoute(
              path: 'searchWorkoutScreen',
              name: RouteConstants.searchWorkoutScreen,
              pageBuilder: (context, state) {
                int number = state.extra as int;
                return CupertinoPage(child: SearchWorkouts(number));
              },
            ),
            GoRoute(
              path: 'viewPostScreen/:id',
              name: RouteConstants.viewPostScreen,
              pageBuilder: (context, state) {
                GenericPost post = state.extra as GenericPost;
                final postId = state.pathParameters['id'];
                return CupertinoPage(
                    child: ViewPost(
                  post: post,
                  postId: postId!,
                ));
              },
            ),
            GoRoute(
              path: 'viewWorkoutScreen',
              name: RouteConstants.viewWorkoutScreen,
              pageBuilder: (context, state) {
                WorkoutModel post = state.extra as WorkoutModel;
                // final postId = state.pathParameters['id'];
                return CupertinoPage(
                    child: ViewWorkout(
                  workoutModel: post,
                  // postId: postId!,
                ));
              },
            ),
            GoRoute(
              path: 'fetchWorkoutScreen',
              name: RouteConstants.fetchingWorkoutScreen,
              pageBuilder: (context, state) {
                String templateId = state.extra as String;
                // final postId = state.pathParameters['id'];
                return CupertinoPage(
                    child: FetchingWorkoutScreen(
                  workoutId: templateId,
                ));
              },
            ),
            GoRoute(
              path: 'runRoutineScreen',
              name: RouteConstants.runRoutineScreen,
              pageBuilder: (context, state) {
                List<WorkoutModel> routineWorkouts =
                    state.extra as List<WorkoutModel>;
                int day = state.extra as int;
                return CupertinoPage(
                    child: RunRoutine(
                  routine: routineWorkouts,
                  day: day,
                ));
              },
            ),
          ])
    ]);
