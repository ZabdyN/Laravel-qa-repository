<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

Route::get('/health', function () {
    try {
        // Intentamos una operación mínima en la base de datos
        DB::connection()->getPdo();
        
        return response()->json([
            'status' => 'ok',
            'database' => 'connected',
            'environment' => app()->environment(),
            'timestamp' => now()->toIso8601String(),
        ], 200);
        
    } catch (\Exception $e) {
        // Si la base de datos no responde, devolvemos un 500 (Server Error)
        return response()->json([
            'status' => 'error',
            'database' => 'disconnected',
            'message' => $e->getMessage(), // ¿Qué propiedad de la excepción $e pondrías aquí para saber qué falló?
        ], 500);
    }
});
