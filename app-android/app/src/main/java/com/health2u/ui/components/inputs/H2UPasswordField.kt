package com.health2u.ui.components.inputs

import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation

/**
 * Health2U Password Field Component
 *
 * Specialized text input field for password entry with show/hide toggle.
 * Includes password visibility toggle button and automatic password keyboard type.
 *
 * Features:
 * - Password masking with toggle button
 * - Show/hide password icon button
 * - Automatic password keyboard type
 * - Error state with error message
 * - Helper text support
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * H2UPasswordField(
 *     value = password,
 *     onValueChange = { password = it },
 *     label = "Password",
 *     isError = password.length < 8,
 *     errorMessage = "Password must be at least 8 characters"
 * )
 * ```
 *
 * @param value Current password value
 * @param onValueChange Callback when password changes
 * @param label Field label text
 * @param modifier Modifier for styling
 * @param placeholder Placeholder text when empty
 * @param helperText Helper text shown below field
 * @param isError Whether field is in error state
 * @param errorMessage Error message shown when isError is true
 * @param enabled Whether field is enabled
 * @param imeAction IME action button
 * @param keyboardActions Keyboard action handlers
 * @param contentDescription Accessibility description
 */
@Composable
fun H2UPasswordField(
    value: String,
    onValueChange: (String) -> Unit,
    label: String,
    modifier: Modifier = Modifier,
    placeholder: String? = null,
    helperText: String? = null,
    isError: Boolean = false,
    errorMessage: String? = null,
    enabled: Boolean = true,
    imeAction: ImeAction = ImeAction.Done,
    keyboardActions: KeyboardActions = KeyboardActions.Default,
    contentDescription: String? = null
) {
    // State for password visibility toggle
    var passwordVisible by remember { mutableStateOf(false) }

    H2UTextField(
        value = value,
        onValueChange = onValueChange,
        label = label,
        modifier = modifier,
        placeholder = placeholder,
        helperText = helperText,
        isError = isError,
        errorMessage = errorMessage,
        enabled = enabled,
        singleLine = true,
        keyboardType = KeyboardType.Password,
        imeAction = imeAction,
        keyboardActions = keyboardActions,
        visualTransformation = if (passwordVisible) {
            VisualTransformation.None
        } else {
            PasswordVisualTransformation()
        },
        trailingIcon = {
            IconButton(
                onClick = { passwordVisible = !passwordVisible }
            ) {
                Icon(
                    imageVector = if (passwordVisible) {
                        Icons.Filled.Visibility
                    } else {
                        Icons.Filled.VisibilityOff
                    },
                    contentDescription = if (passwordVisible) {
                        "Hide password"
                    } else {
                        "Show password"
                    },
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        },
        contentDescription = contentDescription
    )
}
