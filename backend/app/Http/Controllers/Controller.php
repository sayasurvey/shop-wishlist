<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Http\JsonResponse;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

    /**
     * 成功レスポンスを返す
     *
     * @param mixed $data レスポンスデータ
     * @param string $message 成功メッセージ
     * @param int $code HTTPステータスコード
     * @return JsonResponse
     */
    protected function successResponse($data = null, string $message = '操作が成功しました', int $code = 200): JsonResponse
    {
        $response = [
            'success' => true,
            'message' => $message,
            'timestamp' => now()->toISOString(),
        ];

        if ($data !== null) {
            $response['data'] = $data;
        }

        return response()->json($response, $code);
    }

    /**
     * 400 Bad Request エラーレスポンス
     *
     * @param string $message エラーメッセージ
     * @param mixed $errors エラー詳細
     * @return JsonResponse
     */
    protected function badRequestResponse(string $message = 'リクエストが不正です', $errors = null): JsonResponse
    {
        return $this->errorResponse($message, 400, $errors);
    }

    /**
     * 401 Unauthorized エラーレスポンス
     *
     * @param string $message エラーメッセージ
     * @return JsonResponse
     */
    protected function unauthorizedResponse(string $message = '認証が必要です'): JsonResponse
    {
        return $this->errorResponse($message, 401);
    }

    /**
     * 403 Forbidden エラーレスポンス
     *
     * @param string $message エラーメッセージ
     * @return JsonResponse
     */
    protected function forbiddenResponse(string $message = 'この操作を実行する権限がありません'): JsonResponse
    {
        return $this->errorResponse($message, 403);
    }

    /**
     * 404 Not Found エラーレスポンス
     *
     * @param string $resource リソース名
     * @return JsonResponse
     */
    protected function notFoundResponse(string $resource = 'リソース'): JsonResponse
    {
        return $this->errorResponse("{$resource}が見つかりません", 404);
    }

    /**
     * 422 Validation Error エラーレスポンス
     *
     * @param mixed $errors バリデーションエラー
     * @param string $message エラーメッセージ
     * @return JsonResponse
     */
    protected function validationErrorResponse($errors, string $message = 'バリデーションエラーが発生しました'): JsonResponse
    {
        return $this->errorResponse($message, 422, $errors);
    }

    /**
     * 500 Internal Server Error エラーレスポンス
     *
     * @param string $message エラーメッセージ
     * @return JsonResponse
     */
    protected function internalServerErrorResponse(string $message = 'サーバー内部エラーが発生しました'): JsonResponse
    {
        return $this->errorResponse($message, 500);
    }

    /**
     * 503 Service Unavailable エラーレスポンス
     *
     * @param string $message エラーメッセージ
     * @return JsonResponse
     */
    protected function serviceUnavailableResponse(string $message = 'サービスが一時的に利用できません'): JsonResponse
    {
        return $this->errorResponse($message, 503);
    }

    /**
     * 基本エラーレスポンス
     *
     * @param string $message エラーメッセージ
     * @param int $code HTTPステータスコード
     * @param mixed $errors エラー詳細
     * @return JsonResponse
     */
    private function errorResponse(string $message, int $code, $errors = null): JsonResponse
    {
        $response = [
            'success' => false,
            'message' => $message,
            'code' => $code,
            'timestamp' => now()->toISOString(),
        ];

        if ($errors !== null) {
            $response['errors'] = $errors;
        }

        // 本番環境ではデバッグ情報を隠す
        if (app()->environment('production') && $code >= 500) {
            $response['message'] = 'サーバーエラーが発生しました';
        }

        return response()->json($response, $code);
    }
}
