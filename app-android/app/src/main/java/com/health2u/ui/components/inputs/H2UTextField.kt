package com.health2u.ui.components.inputs

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.VisualTransformation
import com.health2u.ui.theme.Dimensions

/**
 * Health2U Text Field Component
 *
 * Standard text input field with label, error state, and helper text support.
 * Follows Material Design 3 outlined text field style.
 *
 * Features:
 * - Label that animates when focused
 * - Error state with error message
 * - Helper text support
 * - Keyboard type configuration
 * - Leading/trailing icons support
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * H2UTextField(
 *     value = email,
 *     onValueChange = { email = it },
 *     label = "Email",
 *     keyboardType = KeyboardType.Email,
 *     isError = !isEmailValid,
 *     errorMessage = "Please enter a valid email"
 * )
 * ```
 *
 * @param value Current text value
 * @param onValueChange Callback when text changes
 * @param label Field label text
 * @param modifier Modifier for styling
 * @param placeholder Placeholder text when empty
 * @param helperText Helper text shown below field
 * @param isError Whether field is in error state
 * @param errorMessage Error message shown when isError is true
 * @param enabled Whether field is enabled
 * @param readOnly Whether field is read-only
 * @param singleLine Whether field should be single line
 * @param maxLines Maximum number of lines (when not single line)
 * @param keyboardType Type of keyboard to show
 * @param imeAction IME action button
 * @param keyboardActions Keyboard action handlers
 * @param visualTransformation Text visual transformation
 * @param leadingIcon Optional leading icon composable
 * @param trailingIcon Optional trailing icon composable
 * @param contentDescription Accessibility description
 */
@Composable
fun H2UTextField(
    value: String,
    onValueChange: (String) -> Unit,
    label: String,
    modifier: Modifier = Modifier,
    placeholder: String? = null,
    helperText: String? = null,
    isError: Boolean = false,
    errorMessage: String? = null,
    enabled: Boolean = true,
    readOnly: Boolean = false,
    singleLine: Boolean = true,
    maxLines: Int = if (singleLine) 1 else Int.MAX_VALUE,
    keyboardType: KeyboardType = KeyboardType.Text,
    imeAction: ImeAction = ImeAction.Next,
    keyboardActions: KeyboardActions = KeyboardActions.Default,
    visualTransformation: VisualTransformation = VisualTransformation.None,
    leadingIcon: @Composable (() -> Unit)? = null,
    trailingIcon: @Composable (() -> Unit)? = null,
    contentDescription: String? = null
) {
    Column(
        modifier = modifier.semantics {
            contentDescription?.let { this.contentDescription = it }
        }
    ) {
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            label = { Text(label) },
            placeholder = placeholder?.let { { Text(it) } },
            modifier = Modifier.fillMaxWidth(),
            enabled = enabled,
            readOnly = readOnly,
            isError = isError,
            singleLine = singleLine,
            maxLines = maxLines,
            keyboardOptions = KeyboardOptions(
                keyboardType = keyboardType,
                imeAction = imeAction
            ),
            keyboardActions = keyboardActions,
            visualTransformation = visualTransformation,
            leadingIcon = leadingIcon,
            trailingIcon = trailingIcon,
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = MaterialTheme.colorScheme.primary,
                unfocusedBorderColor = MaterialTheme.colorScheme.outline,
                errorBorderColor = MaterialTheme.colorScheme.error,
                focusedLabelColor = MaterialTheme.colorScheme.primary,
                unfocusedLabelColor = MaterialTheme.colorScheme.onSurfaceVariant,
                errorLabelColor = MaterialTheme.colorScheme.error,
                cursorColor = MaterialTheme.colorScheme.primary,
                errorCursorColor = MaterialTheme.colorScheme.error
            ),
            shape = MaterialTheme.shapes.small
        )

        // Show error message or helper text
        if (isError && errorMessage != null) {
            Spacer(modifier = Modifier.height(Dimensions.SpaceXS))
            Text(
                text = errorMessage,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.error
            )
        } else if (helperText != null) {
            Spacer(modifier = Modifier.height(Dimensions.SpaceXS))
            Text(
                text = helperText,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}
