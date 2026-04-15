package com.health2u.presentation.welcome

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.EaseOutCubic
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.slideInVertically
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.health2u.ui.theme.Dimensions
import kotlinx.coroutines.delay

// Brand colors used directly for the splash gradient (independent of Material theme)
private val MedicalBlue = Color(0xFF1976D2)
private val MedicalBlueDark = Color(0xFF0D47A1)
private val HealthTeal = Color(0xFF00897B)

@Composable
fun WelcomeScreen(
    onGetStarted: () -> Unit
) {
    // Animation states
    val logoProgress = remember { Animatable(0f) }
    var showContent by remember { mutableStateOf(false) }
    var showButton by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        logoProgress.animateTo(
            targetValue = 1f,
            animationSpec = tween(durationMillis = 1200, easing = EaseOutCubic)
        )
        delay(200)
        showContent = true
        delay(400)
        showButton = true
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(MedicalBlueDark, MedicalBlue, HealthTeal)
                )
            )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = Dimensions.ScreenPaddingHorizontal),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Spacer(modifier = Modifier.weight(1f))

            // Animated logo
            Health2uLogo(progress = logoProgress.value)

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // App name and tagline
            AnimatedVisibility(
                visible = showContent,
                enter = fadeIn(tween(600)) + slideInVertically(
                    animationSpec = tween(600),
                    initialOffsetY = { it / 4 }
                )
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = "Health2U",
                        fontSize = 36.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White,
                        letterSpacing = 1.sp
                    )
                    Spacer(modifier = Modifier.height(Dimensions.SpaceS))
                    Text(
                        text = "Your health, all in one place",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Normal,
                        color = Color.White.copy(alpha = 0.85f),
                        textAlign = TextAlign.Center
                    )
                }
            }

            Spacer(modifier = Modifier.weight(1f))

            // Get Started button
            AnimatedVisibility(
                visible = showButton,
                enter = fadeIn(tween(500)) + slideInVertically(
                    animationSpec = tween(500),
                    initialOffsetY = { it / 2 }
                )
            ) {
                Button(
                    onClick = onGetStarted,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(Dimensions.ButtonHeightLarge),
                    shape = RoundedCornerShape(Dimensions.CornerRadiusXXL),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color.White,
                        contentColor = MedicalBlueDark
                    )
                ) {
                    Text(
                        text = "Get Started",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            }

            Spacer(modifier = Modifier.height(Dimensions.SpaceXXL))
        }
    }
}

/**
 * Compose-drawn Health2U logo: a heart shape formed by a cross (medical)
 * inside a circular pulse ring, all animated with [progress] (0f..1f).
 */
@Composable
private fun Health2uLogo(progress: Float) {
    val size = 140.dp

    Canvas(modifier = Modifier.size(size)) {
        val center = Offset(this.size.width / 2, this.size.height / 2)
        val radius = this.size.minDimension / 2

        // Outer ring (pulse monitor style)
        val ringStroke = Stroke(width = 4.dp.toPx(), cap = StrokeCap.Round)
        drawArc(
            color = Color.White.copy(alpha = 0.3f),
            startAngle = 0f,
            sweepAngle = 360f * progress,
            useCenter = false,
            topLeft = Offset(center.x - radius + 8.dp.toPx(), center.y - radius + 8.dp.toPx()),
            size = Size((radius - 8.dp.toPx()) * 2, (radius - 8.dp.toPx()) * 2),
            style = ringStroke
        )

        // Inner filled circle
        drawCircle(
            color = Color.White.copy(alpha = 0.15f * progress),
            radius = radius * 0.75f * progress,
            center = center
        )

        // Medical cross
        val crossAlpha = (progress * 2f - 0.5f).coerceIn(0f, 1f)
        val crossColor = Color.White.copy(alpha = crossAlpha)
        val crossWidth = 14.dp.toPx()
        val crossLength = radius * 0.55f

        // Vertical bar
        drawRoundRect(
            color = crossColor,
            topLeft = Offset(center.x - crossWidth / 2, center.y - crossLength),
            size = Size(crossWidth, crossLength * 2),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(crossWidth / 2)
        )

        // Horizontal bar
        drawRoundRect(
            color = crossColor,
            topLeft = Offset(center.x - crossLength, center.y - crossWidth / 2),
            size = Size(crossLength * 2, crossWidth),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(crossWidth / 2)
        )

        // Pulse line across the middle
        val pulseAlpha = (progress * 3f - 2f).coerceIn(0f, 1f)
        if (pulseAlpha > 0f) {
            val pulseStroke = Stroke(width = 3.dp.toPx(), cap = StrokeCap.Round)
            val pulseY = center.y
            val startX = center.x - radius * 0.85f
            val endX = startX + (radius * 1.7f) * pulseAlpha

            val path = androidx.compose.ui.graphics.Path().apply {
                moveTo(startX, pulseY)
                // Flat segment
                lineTo(startX + radius * 0.4f, pulseY)
                // Pulse spike
                lineTo(startX + radius * 0.55f, pulseY - radius * 0.3f)
                lineTo(startX + radius * 0.7f, pulseY + radius * 0.2f)
                lineTo(startX + radius * 0.85f, pulseY)
                // Flat segment
                lineTo(endX.coerceAtMost(startX + radius * 1.7f), pulseY)
            }

            drawPath(
                path = path,
                color = Color.White.copy(alpha = pulseAlpha * 0.9f),
                style = pulseStroke
            )
        }
    }
}
