package com.health2u.presentation.editprofile

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import coil.compose.AsyncImage
import com.health2u.ui.components.buttons.PrimaryButton
import com.health2u.ui.components.inputs.H2UTextField
import com.health2u.ui.components.loading.FullScreenLoading
import com.health2u.ui.theme.Dimensions

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EditProfileScreen(
    onNavigateBack: () -> Unit,
    viewModel: EditProfileViewModel = hiltViewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }

    LaunchedEffect(state.error) {
        state.error?.let { error ->
            snackbarHostState.showSnackbar(error)
            viewModel.dismissError()
        }
    }

    LaunchedEffect(state.saveSuccess) {
        if (state.saveSuccess) {
            viewModel.onSaveSuccessHandled()
            onNavigateBack()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Edit Profile",
                        style = MaterialTheme.typography.titleLarge
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface
                )
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) }
    ) { paddingValues ->
        if (state.isLoading) {
            FullScreenLoading()
        } else {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .verticalScroll(rememberScrollState())
                    .padding(
                        horizontal = Dimensions.ScreenPaddingHorizontal,
                        vertical = Dimensions.ScreenPaddingVertical
                    ),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Personal Identity Header
                Text(
                    text = "Personal Identity",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.SpaceS))

                Text(
                    text = "Update your personal information and profile photo",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

                // Avatar with Change Photo
                EditProfileAvatar(
                    profilePictureUrl = state.profilePictureUrl,
                    modifier = Modifier.size(Dimensions.AvatarSizeXL)
                )

                Spacer(modifier = Modifier.height(Dimensions.SpaceS))

                Text(
                    text = "Change Photo",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.clickable { /* TODO: Photo picker */ }
                )

                Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

                // Core Credentials Section
                Text(
                    text = "Core Credentials",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.ContentSpacingM))

                H2UTextField(
                    value = state.name,
                    onValueChange = viewModel::onNameChanged,
                    label = "Full Name",
                    placeholder = "Enter your full name",
                    imeAction = ImeAction.Next,
                    isError = state.nameError != null,
                    errorMessage = state.nameError,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

                H2UTextField(
                    value = state.email,
                    onValueChange = viewModel::onEmailChanged,
                    label = "Email Address",
                    placeholder = "Enter your email",
                    keyboardType = KeyboardType.Email,
                    imeAction = ImeAction.Next,
                    isError = state.emailError != null,
                    errorMessage = state.emailError,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

                H2UTextField(
                    value = state.phone,
                    onValueChange = viewModel::onPhoneChanged,
                    label = "Phone Number",
                    placeholder = "Enter your phone number",
                    keyboardType = KeyboardType.Phone,
                    imeAction = ImeAction.Next,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

                H2UTextField(
                    value = state.dateOfBirth,
                    onValueChange = viewModel::onDateOfBirthChanged,
                    label = "Date of Birth",
                    placeholder = "MM/DD/YYYY",
                    keyboardType = KeyboardType.Number,
                    imeAction = ImeAction.Done,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

                // Action Buttons
                PrimaryButton(
                    text = "Save Changes",
                    onClick = viewModel::onSave,
                    loading = state.isSaving,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(Dimensions.SpaceM))

                TextButton(
                    onClick = onNavigateBack,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = "Cancel",
                        style = MaterialTheme.typography.labelLarge,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                Spacer(modifier = Modifier.height(Dimensions.SpaceL))
            }
        }
    }
}

@Composable
private fun EditProfileAvatar(
    profilePictureUrl: String?,
    modifier: Modifier = Modifier
) {
    if (profilePictureUrl != null) {
        AsyncImage(
            model = profilePictureUrl,
            contentDescription = "Profile picture",
            modifier = modifier.clip(CircleShape),
            contentScale = ContentScale.Crop
        )
    } else {
        Box(
            modifier = modifier
                .clip(CircleShape)
                .background(MaterialTheme.colorScheme.primaryContainer),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Default.Person,
                contentDescription = "Default profile picture",
                modifier = Modifier.size(Dimensions.IconSizeL),
                tint = MaterialTheme.colorScheme.onPrimaryContainer
            )
        }
    }
}
