import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_management_hive_api/config/constants/api_endpoints.dart';
import 'package:student_management_hive_api/features/course/data/dto/get_all_course_dto.dart';
import 'package:student_management_hive_api/features/course/data/model/course_api_model.dart';
import 'package:student_management_hive_api/features/course/domain/entity/course_entity.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/network/http_service.dart';

final courseRemoteDataSourceProvider =
Provider.autoDispose<CourseRemoteDataSource>(
      (ref) => CourseRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class CourseRemoteDataSource{
  final Dio dio;

  CourseRemoteDataSource({required this.dio});

  Future<Either<Failure, List<CourseEntity>>> getAllCoursees() async {
    try{
      var response = await dio.get(ApiEndpoints.getAllCourse);
      if (response.statusCode==200){
        GetAllCourseDTO getAllCourseDTO = GetAllCourseDTO.fromJson(response.data);

        List<CourseEntity> courseList = getAllCourseDTO.data
            .map((course) => CourseAPIModel.toEntity(course))
            .toList();

        return Right(courseList);
      } else {
        return Left (
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.response?.data['message']));
    }
  }
}