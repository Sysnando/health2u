package com.health2u.presentation.login

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Email
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.health2u.ui.components.buttons.PrimaryButton
import com.health2u.ui.components.inputs.H2UPasswordField
import com.health2u.ui.components.inputs.H2UTextField
import com.health2u.ui.theme.Dimensions

@Composable
fun LoginScreen(
    onLoginSuccess: () -> Unit,
    onSignUpClick: () -> Unit
) {
    val focusManager = LocalFocusManager.current

    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var emailError by remember { mutableStateOf<String?>(null) }
    var passwordError by remember { mutableStateOf<String?>(null) }
    var isLoading by remember { mutableStateOf(false) }

    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = Dimensions.ScreenPaddingHorizontal)
                .padding(top = Dimensions.SpaceXXL, bottom = Dimensions.ScreenPaddingVertical),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // Header
            Text(
                text = "Welcome back",
                style = MaterialTheme.typography.headlineLarge,
                color = MaterialTheme.colorScheme.onBackground
            )
            Spacer(modifier = Modifier.height(Dimensions.SpaceS))
            Text(
                text = "Sign in to access your health records",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // Social login buttons
            SocialLoginButton(
                text = "Continue with Google",
                icon = { GoogleIcon(modifier = Modifier.size(20.dp)) },
                onClick = { onLoginSuccess() },
                contentDescription = "Sign in with Google"
            )
            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))
            SocialLoginButton(
                text = "Continue with Apple",
                icon = { AppleIcon(modifier = Modifier.size(20.dp)) },
                onClick = { onLoginSuccess() },
                contentDescription = "Sign in with Apple"
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

            // Divider with "or"
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                HorizontalDivider(
                    modifier = Modifier.weight(1f),
                    color = MaterialTheme.colorScheme.outlineVariant
                )
                Text(
                    text = "or",
                    modifier = Modifier.padding(horizontal = Dimensions.SpaceM),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                HorizontalDivider(
                    modifier = Modifier.weight(1f),
                    color = MaterialTheme.colorScheme.outlineVariant
                )
            }

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

            // Email field
            H2UTextField(
                value = email,
                onValueChange = {
                    email = it
                    emailError = null
                },
                label = "Email",
                placeholder = "you@example.com",
                keyboardType = KeyboardType.Email,
                imeAction = ImeAction.Next,
                keyboardActions = KeyboardActions(
                    onNext = { focusManager.moveFocus(FocusDirection.Down) }
                ),
                isError = emailError != null,
                errorMessage = emailError,
                leadingIcon = {
                    Icon(
                        imageVector = Icons.Filled.Email,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingM))

            // Password field
            H2UPasswordField(
                value = password,
                onValueChange = {
                    password = it
                    passwordError = null
                },
                label = "Password",
                placeholder = "Enter your password",
                imeAction = ImeAction.Done,
                keyboardActions = KeyboardActions(
                    onDone = {
                        focusManager.clearFocus()
                        performLogin(
                            email = email,
                            password = password,
                            onEmailError = { emailError = it },
                            onPasswordError = { passwordError = it },
                            onLoading = { isLoading = it },
                            onSuccess = onLoginSuccess
                        )
                    }
                ),
                isError = passwordError != null,
                errorMessage = passwordError,
                modifier = Modifier.fillMaxWidth()
            )

            // Forgot password
            Spacer(modifier = Modifier.height(Dimensions.SpaceS))
            Text(
                text = "Forgot password?",
                modifier = Modifier
                    .align(Alignment.End)
                    .clickable { /* TODO */ },
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.primary
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

            // Login button
            PrimaryButton(
                text = "Sign In",
                onClick = {
                    focusManager.clearFocus()
                    performLogin(
                        email = email,
                        password = password,
                        onEmailError = { emailError = it },
                        onPasswordError = { passwordError = it },
                        onLoading = { isLoading = it },
                        onSuccess = onLoginSuccess
                    )
                },
                loading = isLoading,
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.weight(1f))
            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

            // Sign up prompt
            Row(
                horizontalArrangement = Arrangement.Center,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    text = "Don't have an account? ",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(
                    text = "Sign Up",
                    modifier = Modifier.clickable { onSignUpClick() },
                    style = MaterialTheme.typography.bodyMedium.copy(fontWeight = FontWeight.SemiBold),
                    color = MaterialTheme.colorScheme.primary
                )
            }
        }
    }
}

private fun performLogin(
    email: String,
    password: String,
    onEmailError: (String?) -> Unit,
    onPasswordError: (String?) -> Unit,
    onLoading: (Boolean) -> Unit,
    onSuccess: () -> Unit
) {
    // Reset errors
    onEmailError(null)
    onPasswordError(null)

    // Basic client-side validation
    var hasError = false

    if (email.isBlank()) {
        onEmailError("Email is required")
        hasError = true
    } else if (!android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
        onEmailError("Enter a valid email address")
        hasError = true
    }

    if (password.isBlank()) {
        onPasswordError("Password is required")
        hasError = true
    } else if (password.length < 6) {
        onPasswordError("Password must be at least 6 characters")
        hasError = true
    }

    if (hasError) return

    // Fake login — skip backend, just proceed
    onSuccess()
}

// ---------- Social login button ----------

@Composable
private fun SocialLoginButton(
    text: String,
    icon: @Composable () -> Unit,
    onClick: () -> Unit,
    contentDescription: String
) {
    Surface(
        onClick = onClick,
        modifier = Modifier
            .fillMaxWidth()
            .height(Dimensions.ButtonHeight),
        shape = RoundedCornerShape(Dimensions.CornerRadiusM),
        color = MaterialTheme.colorScheme.surface,
        border = androidx.compose.foundation.BorderStroke(
            width = 1.dp,
            color = MaterialTheme.colorScheme.outline
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = Dimensions.ButtonPaddingHorizontal),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            icon()
            Spacer(modifier = Modifier.width(Dimensions.ContentSpacingS))
            Text(
                text = text,
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.onSurface
            )
        }
    }
}

// ---------- Compose-drawn brand icons ----------

@Composable
private fun GoogleIcon(modifier: Modifier = Modifier) {
    Canvas(modifier = modifier) {
        val s = size.minDimension
        val cx = s / 2f
        val cy = s / 2f
        val r = s * 0.45f
        val stroke = Stroke(width = s * 0.12f, cap = StrokeCap.Butt)

        // Red arc (top-right)
        drawArc(
            color = Color(0xFFEA4335),
            startAngle = -10f, sweepAngle = -80f,
            useCenter = false, style = stroke,
            topLeft = Offset(cx - r, cy - r),
            size = androidx.compose.ui.geometry.Size(r * 2, r * 2)
        )
        // Yellow arc (bottom-right)
        drawArc(
            color = Color(0xFFFBBC05),
            startAngle = -90f, sweepAngle = -90f,
            useCenter = false, style = stroke,
            topLeft = Offset(cx - r, cy - r),
            size = androidx.compose.ui.geometry.Size(r * 2, r * 2)
        )
        // Green arc (bottom-left)
        drawArc(
            color = Color(0xFF34A853),
            startAngle = 180f, sweepAngle = -90f,
            useCenter = false, style = stroke,
            topLeft = Offset(cx - r, cy - r),
            size = androidx.compose.ui.geometry.Size(r * 2, r * 2)
        )
        // Blue arc (top-left) + horizontal bar
        drawArc(
            color = Color(0xFF4285F4),
            startAngle = -10f, sweepAngle = 100f,
            useCenter = false, style = stroke,
            topLeft = Offset(cx - r, cy - r),
            size = androidx.compose.ui.geometry.Size(r * 2, r * 2)
        )
        // Horizontal bar
        drawLine(
            color = Color(0xFF4285F4),
            start = Offset(cx, cy),
            end = Offset(cx + r + s * 0.06f, cy),
            strokeWidth = s * 0.12f,
            cap = StrokeCap.Butt
        )
    }
}

@Composable
private fun AppleIcon(modifier: Modifier = Modifier) {
    val color = MaterialTheme.colorScheme.onSurface
    Canvas(modifier = modifier) {
        val s = size.minDimension
        // Simplified apple shape using a path
        val path = Path().apply {
            // Apple body
            moveTo(s * 0.5f, s * 0.25f)
            cubicTo(s * 0.18f, s * 0.25f, s * 0.08f, s * 0.48f, s * 0.14f, s * 0.68f)
            cubicTo(s * 0.20f, s * 0.88f, s * 0.35f, s * 0.98f, s * 0.45f, s * 0.98f)
            cubicTo(s * 0.48f, s * 0.98f, s * 0.52f, s * 0.95f, s * 0.55f, s * 0.98f)
            cubicTo(s * 0.65f, s * 0.98f, s * 0.80f, s * 0.88f, s * 0.86f, s * 0.68f)
            cubicTo(s * 0.92f, s * 0.48f, s * 0.82f, s * 0.25f, s * 0.5f, s * 0.25f)
            close()
        }
        drawPath(path = path, color = color)

        // Stem
        drawLine(
            color = color,
            start = Offset(s * 0.50f, s * 0.25f),
            end = Offset(s * 0.55f, s * 0.07f),
            strokeWidth = s * 0.06f,
            cap = StrokeCap.Round
        )

        // Leaf
        val leaf = Path().apply {
            moveTo(s * 0.55f, s * 0.10f)
            cubicTo(s * 0.60f, s * 0.02f, s * 0.72f, s * 0.02f, s * 0.72f, s * 0.10f)
            cubicTo(s * 0.72f, s * 0.17f, s * 0.60f, s * 0.18f, s * 0.55f, s * 0.10f)
            close()
        }
        drawPath(path = leaf, color = color)
    }
}
