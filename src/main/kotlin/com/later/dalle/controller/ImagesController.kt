package co.mavrck.tiktok.webapp.controller

import com.later.dalle.domain.ImageResponse
import com.later.dalle.service.ImageService

import org.jetbrains.annotations.NotNull
import org.springframework.validation.annotation.Validated
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import javax.validation.Valid
import mu.KotlinLogging


@RestController
@RequestMapping("/images")
@Validated
class ImagesController(val imageService: ImageService) {

    private val logger = KotlinLogging.logger {}
    @GetMapping
    fun getImage(
        @Valid @NotNull @PathVariable descriptivePrompt: String,
    ): ImageResponse {
        val image: ImageResponse
        try {
            image = imageService.getImage(descriptivePrompt)
            return ImageResponse(
                description = "hello",
                name = "hello",
            )
        } catch (e: Exception) {
            logger.error(e) { "ImagesController::getImage Error getting image" }
            throw e
        }
        return image;
    }
}
