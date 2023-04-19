package com.later.dalle.service

import com.later.dalle.domain.ImageResponse
import org.springframework.stereotype.Service

@Service
class ImageService {
    fun getImage(descriptivePrompt: String): ImageResponse {
        return ImageResponse(
            description = "hello",
            name = "hello",
        )
    }
}