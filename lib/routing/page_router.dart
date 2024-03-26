import 'package:fitness_social_app/auth/auth_state.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/meal_model.dart';
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
import 'package:fitness_social_app/screen/local_exercise_edit_screen.dart';
import 'package:fitness_social_app/screen/run_routine.dart';
import 'package:fitness_social_app/screen/run_workou.dart';
import 'package:fitness_social_app/screen/search_meals.dart';
import 'package:fitness_social_app/screen/search_screens/search_screen.dart';
import 'package:fitness_social_app/screen/search_workouts.dart';
import 'package:fitness_social_app/screen/user_page.dart';
import 'package:fitness_social_app/screen/user_saved_workouts.dart';
import 'package:fitness_social_app/screen/user_stats_screen.dart';
import 'package:fitness_social_app/screen/view_meal_plan.dart';
import 'package:fitness_social_app/screen/view_meal_screen.dart';
import 'package:fitness_social_app/screen/view_post.dart';
import 'package:fitness_social_app/screen/view_routine.dart';
import 'package:fitness_social_app/screen/view_workout.dart';
import 'package:fitness_social_app/services/drafts.dart';
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
              path: 'createMealPage',
              name: RouteConstants.createMeal,
              pageBuilder: (context, state) {
                return const CupertinoPage(child: CreateMealPost());
              },
            ),
            GoRoute(
              path: 'viewMealPlanScreen/:id',
              name: RouteConstants.viewMealPlanScreen,
              pageBuilder: (context, state) {
                final uid = state.pathParameters['id'];
                int currentDay = state.extra as int;
                return CupertinoPage(
                    child: ViewMealPlanScreen(
                  currentDay: currentDay,
                  uid: uid!,
                ));
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
                List<LocalExerciseModel> exercises =
                    state.extra as List<LocalExerciseModel>;
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
                        index: exerciseParams['index']));
              },
            ),
            GoRoute(
              path: 'localEditExercisePage',
              name: RouteConstants.localEditWorkout,
              pageBuilder: (context, state) {
                // ExerciseModel exerciseModel = state.extra as ExerciseModel;
                final exerciseParams = state.extra! as Map<String, dynamic>;
                return CupertinoPage(
                    child: LocalExerciseEditScreen(
                        localExerciseModel: exerciseParams["editingExercise"],
                        index: exerciseParams['index']));
              },
            ),
            GoRoute(
              path: 'viewRotinePage/:id',
              name: RouteConstants.viewRoutinePage,
              pageBuilder: (context, state) {
                final uid = state.pathParameters['id'];
                final viewRoutineExtras = state.extra! as Map<String, dynamic>;
                return CupertinoPage(
                    child: ViewRoutine(
                  uid: uid!,
                  currentDay: viewRoutineExtras['currentDay'],
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
              path: 'searchMealsScreen',
              name: RouteConstants.searchMealsScreen,
              pageBuilder: (context, state) {
                return const CupertinoPage(child: SearchMeals());
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
                int currentDay = state.extra as int;
                return CupertinoPage(
                    child: RunRoutine(
                  currentDay: currentDay,
                ));
              },
            ),
            GoRoute(
              path: 'runWorkoutScreen',
              name: RouteConstants.runWorkoutScreen,
              pageBuilder: (context, state) {
                List<WorkoutModel> workouts = state.extra as List<WorkoutModel>;
                return CupertinoPage(
                    child: RunWorkout(
                  workouts: workouts,
                ));
              },
            ),
            GoRoute(
              path: 'viewMealScreen',
              name: RouteConstants.viewMealScreen,
              pageBuilder: (context, state) {
                MealModel meal = state.extra as MealModel;
                return CupertinoPage(
                    child: ViewMealScreen(
                  mealModel: meal,
                ));
              },
            ),
            GoRoute(
              path: 'viewUserStatsScreen/:id',
              name: RouteConstants.viewUserStatsScreen,
              pageBuilder: (context, state) {
                final postId = state.pathParameters['id'];
                return CupertinoPage(
                    child: UserStatsScreen(
                  uid: postId!,
                ));
              },
            ),
            GoRoute(
              path: 'viewUserSavedWorkouts/:id',
              name: RouteConstants.viewUserSavedWorkouts,
              pageBuilder: (context, state) {
                final postId = state.pathParameters['id'];
                return CupertinoPage(
                    child: UserSavedWorkouts(
                  uid: postId!,
                ));
              },
            ),
            GoRoute(
              path: 'searchScreen/:searchType',
              name: RouteConstants.searchScreen,
              pageBuilder: (context, state) {
                final searchType = state.pathParameters['searchType'];
                return CupertinoPage(
                    child: SearchScreen(
                  searchType: searchType!,
                ));
              },
            ),
          ])
    ]);
